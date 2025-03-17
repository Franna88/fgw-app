import 'package:farming_gods_way/Crop_fields/ui/fieldListItem.dart';
import 'package:flutter/material.dart';

import '../CommonUi/Buttons/commonButton.dart';
import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Constants/myutility.dart';
import 'pages/createNewField.dart';
import 'pages/cropFieldView.dart';

class CropFields extends StatefulWidget {
  const CropFields({super.key});

  @override
  State<CropFields> createState() => _CropFieldsState();
}

class _CropFieldsState extends State<CropFields> {
  List<Map<String, String>> fields = [];

  void _navigateToCreateField() async {
    final newField = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateNewField()),
    );

    if (newField != null) {
      setState(() {
        fields.add(newField);
      });
    }
  }

  void _navigateToFieldView(Map<String, String> field) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CropFieldView(field: field),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().forestGreen,
      body: SafeArea(
        child: Column(
          children: [
            const FgwTopBar(),
            const SizedBox(height: 15),
            const CornerHeaderContainer(header: 'Crop Fields', hasBackArrow: false),
            const SizedBox(height: 15),
            CommonButton(
              customHeight: 38,
              customWidth: MyUtility(context).width * 0.93,
              buttonText: 'Add Fields',
              textColor: MyColors().black,
              buttonColor: MyColors().yellow,
              onTap: _navigateToCreateField,
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                width: MyUtility(context).width * 0.93,
                decoration: BoxDecoration(
                  color: MyColors().offWhite,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: ListView.builder(
                  itemCount: fields.length,
                  itemBuilder: (context, index) {
                    final field = fields[index];
                    return GestureDetector(
                      onTap: () => _navigateToFieldView(field),
                      child: FieldListItem(
                        fieldName: field['name']!,
                        imagePath: field['image']!,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}