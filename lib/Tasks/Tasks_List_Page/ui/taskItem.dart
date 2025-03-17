import 'package:farming_gods_way/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constants/myutility.dart';

class TaskItem extends StatelessWidget {
  final bool hasImage;
  const TaskItem({super.key, required this.hasImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: hasImage,
          child: Container(
            height: MyUtility(context).height * 0.25,
            width: MyUtility(context).width * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              image: DecorationImage(
                image: AssetImage('images/tomatos.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Container(
          //height: 115,
          width: MyUtility(context).width * 0.85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //if marked as important
                  Container(
                    width: MyUtility(context).width * 0.20,
                    height: 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        color: MyColors().brightRed),
                  ),
                  Container(
                    height: 30,
                    width: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                      ),
                      color: MyColors().yellow,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Complete before 2024/04/05',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  Container(
                    //color: Colors.amber,
                    width: MyUtility(context).width * 0.85 - 78,
                    child: Text(
                      //Task
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
                      style: GoogleFonts.roboto(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(
                    Icons.more_vert,
                    size: 30,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
