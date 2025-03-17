import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledDropDown.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labledDatePicker.dart';
import 'package:flutter/material.dart';

import '../../CommonUi/cornerHeaderContainer.dart';
import '../../Constants/colors.dart';
import '../../Constants/myutility.dart';

class AddProductionRecord extends StatefulWidget {
  const AddProductionRecord({super.key});

  @override
  State<AddProductionRecord> createState() => _AddProductionRecordState();
}

class _AddProductionRecordState extends State<AddProductionRecord> {
  final entryDate = TextEditingController();
  final productQuantity = TextEditingController();
  String? selectedProduct;

  void _saveRecord() {
    if (entryDate.text.isNotEmpty &&
        selectedProduct != null &&
        productQuantity.text.isNotEmpty) {
      final newRecord = {
        'date': entryDate.text,
        'product': selectedProduct!,
        'productQuantity': productQuantity.text,
      };
      Navigator.pop(context, newRecord);
    }
  }

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
                borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    CornerHeaderContainer(
                        header: 'Add Production Record', hasBackArrow: true),
                    const SizedBox(height: 15),
                    LabeledDatePicker(
                        label: 'Entry Date',
                        hintText: '',
                        controller: entryDate),
                    const SizedBox(height: 15),
                    LabeledDropdown(
                      label: 'Product',
                      hintText: '',
                      items: ['Carrot', 'Tomatoes', 'Beetroot'],
                      onChanged: (value) =>
                          setState(() => selectedProduct = value),
                    ),
                    const SizedBox(height: 15),
                    LabeledTextField(
                        label: 'Product Quantity',
                        hintText: '',
                        controller: productQuantity),
                    const Spacer(),
                    CommonButton(
                      customWidth: MyUtility(context).width * 0.5,
                      buttonText: 'Save',
                      onTap: _saveRecord,
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
