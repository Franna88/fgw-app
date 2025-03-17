import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Constants/colors.dart';
import '../../../../Constants/myutility.dart';
import '../../Create_Portion/addCrop.dart';

class AddCropContainer extends StatefulWidget {
  final Function(String crop, String cropFaze, String dayCount, String rowNumber) onSave;

  const AddCropContainer({super.key, required this.onSave});

  @override
  State<AddCropContainer> createState() => _AddCropContainerState();
}

class _AddCropContainerState extends State<AddCropContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Navigate to AddCrop page and wait for the user input
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddCrop()),
        );

        if (result != null) {
          // Pass the result back to the parent widget (PortionItem)
          widget.onSave(result['crop'], result['cropFaze'], result['dayCount'], result['rowNumber']);
        }
      },
      child: Container(
        height: 70,
        width: MyUtility(context).width * 0.90 - 79,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 70,
              decoration: BoxDecoration(
                color: MyColors().black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            Text(
              'Add Crop',
              style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}