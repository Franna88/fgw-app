import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactDisplay extends StatefulWidget {
  final String image;
  final String userName;
  const ContactDisplay(
      {super.key, required this.image, required this.userName});

  @override
  State<ContactDisplay> createState() => _ContactDisplayState();
}

class _ContactDisplayState extends State<ContactDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: MyUtility(context).width * 0.90,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                blurRadius: 5,
                color: const Color.fromARGB(255, 160, 160, 160),
                offset: Offset(2, 2)),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(widget.image),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              widget.userName,
              style: GoogleFonts.roboto(fontSize: 20),
            ),
            const Spacer(),
            IconButton(
              onPressed: () async {
                final RenderBox button =
                    context.findRenderObject() as RenderBox;
                final overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;
                final Offset position =
                    button.localToGlobal(Offset.zero, ancestor: overlay);

                await showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    position.dx,
                    position.dy,
                    overlay.size.width - position.dx,
                    overlay.size.height - position.dy,
                  ),
                  items: [
                    PopupMenuItem(
                      value: 'remove',
                      child: Text('Remove Contact'),
                    ),
                  ],
                ).then((value) {
                  if (value == 'remove') {
                    // Handle remove logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${widget.userName} removed.')),
                    );
                  }
                });
              },
              icon: Icon(
                size: 35,
                Icons.more_vert_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
