import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: MyColors().forestGreen,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white.withOpacity(0.9),
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.date,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.white.withOpacity(0.9),
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.time,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.comments,
                        color: Colors.white.withOpacity(0.9),
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.repliesTotal,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // User Info
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(widget.userImage),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: MyColors().lightGreen.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.userName,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: MyColors().forestGreen,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.verified,
                            size: 18,
                            color: MyColors().forestGreen.withOpacity(0.7),
                          ),
                        ],
                      ),
                      Text(
                        'Expert Farmer',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Message
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              widget.topicMessage,
              style: GoogleFonts.roboto(
                fontSize: 16,
                height: 1.4,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          ),
          
          // Tags
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTag('Farming'),
                _buildTag('Sustainable'),
                _buildTag('Tips'),
              ],
            ),
          ),
          
          // Engagement stats
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(FontAwesomeIcons.thumbsUp, '14'),
                  const SizedBox(width: 20),
                  _buildStat(FontAwesomeIcons.comment, widget.repliesTotal.split(' ')[0]),
                  const SizedBox(width: 20),
                  _buildStat(FontAwesomeIcons.share, '5'),
                  const SizedBox(width: 20),
                  _buildStat(FontAwesomeIcons.bookmark, 'Save'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: MyColors().lightGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: MyColors().lightGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: MyColors().forestGreen,
        ),
      ),
    );
  }
  
  Widget _buildStat(IconData icon, String count) {
    return Row(
      children: [
        Icon(
          icon, 
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 6),
        Text(
          count,
          style: GoogleFonts.roboto(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
