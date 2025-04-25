import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactDisplay extends StatefulWidget {
  final String image;
  final String userName;
  final VoidCallback? onTap;
  
  const ContactDisplay({
    super.key, 
    required this.image, 
    required this.userName,
    this.onTap,
  });

  @override
  State<ContactDisplay> createState() => _ContactDisplayState();
}

class _ContactDisplayState extends State<ContactDisplay> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
          
          if (widget.onTap != null) {
            widget.onTap!();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Selected ${widget.userName}'),
                backgroundColor: MyColors().forestGreen,
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
        child: Container(
          height: 75,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected 
                ? Border.all(color: MyColors().forestGreen, width: 2) 
                : null,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: MyColors().lightGreen.withOpacity(0.2),
                backgroundImage: AssetImage(widget.image),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.userName,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: MyColors().black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Farmer',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.message,
                      size: 18,
                      color: MyColors().forestGreen,
                    ),
                    onPressed: () {
                      if (widget.onTap != null) {
                        widget.onTap!();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Messaging ${widget.userName}'),
                            backgroundColor: MyColors().forestGreen,
                          ),
                        );
                      }
                    },
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: Colors.grey[700],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    onSelected: (value) {
                      if (value == 'remove') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.userName} removed.'),
                            backgroundColor: MyColors().brightRed,
                          ),
                        );
                      } else if (value == 'block') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.userName} blocked.'),
                            backgroundColor: MyColors().forestGreen,
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility, size: 18, color: MyColors().forestGreen),
                            const SizedBox(width: 8),
                            const Text('View Profile'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'block',
                        child: Row(
                          children: [
                            Icon(Icons.block, size: 18, color: Colors.orange),
                            const SizedBox(width: 8),
                            const Text('Block Contact'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: MyColors().brightRed),
                            const SizedBox(width: 8),
                            const Text('Remove Contact'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
