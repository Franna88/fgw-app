import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../CommonUi/Buttons/commonButton.dart';
import '../../Constants/myutility.dart';
import '../../Messages/Messages.dart';

class UserBlock extends StatefulWidget {
  final String userImage;
  final String userName;
  const UserBlock({super.key, required this.userImage, required this.userName});

  @override
  State<UserBlock> createState() => _UserBlockState();
}

class _UserBlockState extends State<UserBlock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MyUtility(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromRGBO(245, 244, 227, 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.userImage),fit: BoxFit.fill
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                CommonButton(
                  customHeight: 35,
                  customWidth: MyUtility(context).width * 0.50,
                  buttonText: 'Message',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Messages(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
