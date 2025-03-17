import 'package:flutter/material.dart';

class MyBackArrowButton extends StatelessWidget {
  const MyBackArrowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 35,
        width: 35,
        decoration: ShapeDecoration(
          shadows: [
            BoxShadow(
              offset: Offset(0, 4),
              color: const Color.fromARGB(255, 201, 201, 201),
              blurRadius: 3
            ),
          ],
          color: Colors.white,
          shape: CircleBorder(),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
    );
  }
}
