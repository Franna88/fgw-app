import 'package:farming_gods_way/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CircleButtons extends StatelessWidget {
  final IconData icon;
  final bool hasNotification;
  final Function() onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;

  const CircleButtons({
    super.key,
    required this.icon,
    required this.hasNotification,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        splashColor: myColors.lightGreen.withOpacity(0.2),
        highlightColor: myColors.lightGreen.withOpacity(0.1),
        child: Ink(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  icon,
                  size: iconSize ?? 22,
                  color: iconColor ?? myColors.black,
                ),
              ),
              if (hasNotification)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: myColors.brightRed,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                  ).animate(onPlay: (controller) => controller.repeat())
                    .scaleXY(
                      begin: 0.8,
                      end: 1.1,
                      duration: 1000.ms,
                      curve: Curves.easeInOutSine,
                    ).then(delay: 300.ms)
                    .scaleXY(
                      begin: 1.1,
                      end: 0.8,
                      duration: 1000.ms,
                      curve: Curves.easeInOutSine,
                    ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
