import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FullForumPostItem extends StatefulWidget {
  final String date;
  final String topicMessage;
  final String userName;
  final String userImage;
  final String time;
  final String repliesTotal;

  const FullForumPostItem(
      {super.key,
      required this.date,
      required this.topicMessage,
      required this.userName,
      required this.userImage,
      required this.time,
      required this.repliesTotal});

  @override
  State<FullForumPostItem> createState() => _FullForumPostItemState();
}

class _FullForumPostItemState extends State<FullForumPostItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, right: 10, top: 5),
      child: SizedBox(
        height: 104,
        width: MyUtility(context).width * 0.88,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: MyUtility(context).width * 0.60,
              height: 30,
              decoration: BoxDecoration(
                color: MyColors().black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.date,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.time,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.repliesTotal,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MyUtility(context).width * 0.88,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.userImage),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName,
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: MyUtility(context).width - 125,
                          child: Text(
                            widget.topicMessage,
                            style: GoogleFonts.roboto(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
