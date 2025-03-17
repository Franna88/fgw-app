import 'package:farming_gods_way/Constants/colors.dart';
import 'package:flutter/material.dart';

class CircleButtons extends StatelessWidget {
  final IconData icon;
  final bool hasNotification;
  final Function() onTap;

  const CircleButtons({
    super.key,
    required this.icon,
    required this.hasNotification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 45,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: CircleBorder(),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                icon,
                size: 28,
              ),
            ),
            Visibility(
              visible: hasNotification == true,
              child: Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  height: 15,
                  width: 15,
                  decoration: ShapeDecoration(
                      shape: CircleBorder(), color: MyColors().red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
