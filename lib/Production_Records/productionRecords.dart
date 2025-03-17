import 'package:farming_gods_way/CommonUi/Buttons/myDropDownButton.dart';
import 'package:farming_gods_way/Production_Records/pages/addProductionRecord.dart';
import 'package:farming_gods_way/Production_Records/ui/productionRecordItem.dart';
import 'package:flutter/material.dart';

import '../CommonUi/Buttons/commonButton.dart';
import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Constants/myutility.dart';

class ProductionRecords extends StatefulWidget {
  const ProductionRecords({super.key});

  @override
  State<ProductionRecords> createState() => _ProductionRecordsState();
}

class _ProductionRecordsState extends State<ProductionRecords> {
  List<Map<String, String>> productionRecords = [];
  String? selectedMonth;

  void _addRecord(Map<String, String> record) {
    setState(() {
      productionRecords.add(record);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecords = selectedMonth == null
        ? productionRecords
        : productionRecords
            .where((record) => record['date']!.contains(selectedMonth!))
            .toList();

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
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CornerHeaderContainer(
                        header: 'Production Records', hasBackArrow: true),
                    const SizedBox(height: 15),
                    CommonButton(
                      buttonColor: MyColors().yellow,
                      textColor: MyColors().black,
                      customWidth: MyUtility(context).width * 0.93,
                      buttonText: 'Add Record Entry',
                      onTap: () async {
                        final newRecord = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AddProductionRecord()),
                        );
                        if (newRecord != null) {
                          _addRecord(newRecord);
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    MyDropDownButton(
                      items: [
                        'January',
                        'February',
                        'March',
                        'April',
                        'May',
                        'June',
                        'July',
                        'August',
                        'September',
                        'October',
                        'November',
                        'December'
                      ],
                      customWidth: MyUtility(context).width * 0.4,
                      onChanged: (value) {
                        setState(() {
                          selectedMonth = value;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: MyUtility(context).height - 259,
                      width: MyUtility(context).width * 0.93,
                      decoration: BoxDecoration(
                        color: MyColors().offWhite,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      child: ListView.builder(
                        itemCount: filteredRecords.length,
                        itemBuilder: (context, index) {
                          final record = filteredRecords[index];
                          return ProductionRecordItem(
                            date: record['date']!,
                            product: record['product']!,
                            productQuantity: record['productQuantity']!,
                          );
                        },
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
