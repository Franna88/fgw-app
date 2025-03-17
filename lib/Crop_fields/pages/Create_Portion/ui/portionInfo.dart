import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Constants/myutility.dart';

class PortionInfo extends StatelessWidget {
  final String text;
  final String amounts;
  const PortionInfo({super.key, required this.text, required this.amounts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: MyUtility(context).width * 0.88,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.circle_outlined),
            const SizedBox(width: 5,),
            Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: MyUtility(context).width < 390 ? 15 : 18,
              ),
            ),
            const Spacer(),
            Text(
              amounts,
              style: GoogleFonts.roboto(
                fontSize: MyUtility(context).width < 390 ? 15 : 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
