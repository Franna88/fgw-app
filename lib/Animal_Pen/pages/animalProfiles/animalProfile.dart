import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';

class AnimalProfile extends StatefulWidget {
  const AnimalProfile({super.key});

  @override
  State<AnimalProfile> createState() => _AnimalProfileState();
}

class _AnimalProfileState extends State<AnimalProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().offWhite,
      body: SizedBox(
        height: MyUtility(context).height,
        width: MyUtility(context).width,
        child: Column(
          children: [
            SizedBox(height: MyUtility(context).height * 0.05),
            Container(
              height: MyUtility(context).height * 0.95,
              width: MyUtility(context).width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [MyColors().forestGreen, MyColors().lightGreen],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CornerHeaderContainer(
                        header: 'Animal Profile', hasBackArrow: true),
                    const SizedBox(height: 15),
                    Container(
                      height: MyUtility(context).height * 0.35,
                      width: MyUtility(context).width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage('images/livestock.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 50,
                          width: MyUtility(context).width,
                          decoration: BoxDecoration(
                            color: MyColors().black,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Samy',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  '2 Years',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                Icon(
                                  size: 35,
                                  Icons.female,
                                  color: Colors.deepPurple,
                                  // widget.animalGender == 'male'
                                  //     ? Icons.male
                                  //     : widget.animalGender == 'female'
                                  //         ? Icons.female
                                  //         : Icons.drag_handle,
                                  // color: widget.animalGender == 'male'
                                  //     ? Colors.blueAccent
                                  //     : widget.animalGender == 'female'
                                  //         ? Colors.deepPurple
                                  //         : Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CommonButton(
                      customWidth: MyUtility(context).width,
                      buttonText: 'Health Records',
                      onTap: () {},
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: MyUtility(context).height * 0.58 - 161,
                      width: MyUtility(context).width * 0.93,
                      decoration: BoxDecoration(
                        color: MyColors().offWhite,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                             const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 60,
                              width: MyUtility(context).width - 60,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(2, 2),
                                      color: const Color.fromARGB(
                                          255, 146, 146, 146),
                                      blurRadius: 5),
                                ],
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: true,
                                    onChanged: (value) {},
                                    activeColor: MyColors().black,
                                    checkColor: Colors.amber,
                                  ),
                                  Text(
                                    'Pregnancy Track',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 110,
                              width: MyUtility(context).width - 60,
                              decoration: BoxDecoration(
                                color: MyColors().black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pregnancy Start Date',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      height: 40,
                                      width: MyUtility(context).width - 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, left: 8),
                                        child: Text(
                                          '02 DEC 2024',
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 18),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 110,
                              width: MyUtility(context).width - 60,
                              decoration: BoxDecoration(
                                color: MyColors().black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pregnancy Start Date',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      height: 40,
                                      width: MyUtility(context).width - 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, left: 8),
                                        child: Text(
                                          '02 DEC 2024',
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 18),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
