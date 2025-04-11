import 'package:farming_gods_way/Animal_Pen/newAnimalField.dart';
import 'package:farming_gods_way/Animal_Pen/pages/animalFieldView.dart';
import 'package:flutter/material.dart';

import '../CommonUi/Buttons/commonButton.dart';
import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Constants/myutility.dart';
import '../Crop_fields/pages/createNewField.dart';
import '../Crop_fields/ui/fieldListItem.dart';

class AnimalFields extends StatefulWidget {
  const AnimalFields({super.key});

  @override
  State<AnimalFields> createState() => _AnimalFieldsState();
}

class _AnimalFieldsState extends State<AnimalFields> {
  List<Map<String, String>> fields = [];

  void _navigateToCreateField() async {
    final newField = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewAnimalField()),
    );

    if (newField != null && mounted) {
      setState(() {
        fields.add(Map<String, String>.from(newField));
      });
    }
  }

  void _navigateToFieldView(Map<String, String> field) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalFieldView(field: field),
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
            const CornerHeaderContainer(
                header: 'Animal Pen', hasBackArrow: false),
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
