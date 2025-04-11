import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';

import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';

import 'package:flutter/material.dart';

import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class NewForumPost extends StatefulWidget {
  const NewForumPost({super.key});

  @override
  State<NewForumPost> createState() => _NewForumPostState();
}

class _NewForumPostState extends State<NewForumPost> {
  @override
  Widget build(BuildContext context) {
    final post_Headline = TextEditingController();
    final post = TextEditingController();
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
                borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    CornerHeaderContainer(
                        header: 'New Post', hasBackArrow: true),
                    const SizedBox(height: 15),
                    LabeledTextField(
                        label: 'Post Headline',
                        hintText: '',
                        controller: post_Headline),
                        const SizedBox(height: 15),
                    LabeledTextField(
                        label: 'Post',
                        hintText: '',
                        controller: post, lines: 8,),
                    const Spacer(),
                    CommonButton(
                      customWidth: MyUtility(context).width * 0.5,
                      buttonText: 'Post',
                      onTap: (){},
                    ),
                    const SizedBox(height: 20),
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
