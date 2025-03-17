import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';

import 'package:farming_gods_way/Crop_fields/pages/farmPortions/ui/portionItem.dart';
import 'package:flutter/material.dart';

import '../../../CommonUi/cornerHeaderContainer.dart';
import '../../../Constants/colors.dart';
import '../../../Constants/myutility.dart';
import '../Create_Portion/newPortion.dart';

class FarmPortionsPage extends StatefulWidget {
  const FarmPortionsPage({super.key});

  @override
  State createState() => _FarmPortionsPageState();
}

class _FarmPortionsPageState extends State {
  final List<PortionItem> _portions = [];

  void _addPortion(String portionName, String rowLength, String portionType) {
    setState(() {
      _portions.add(PortionItem(
        portionName: portionName,
        //rowLength: rowLength,
        portionType: portionType,
      ));
    });
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
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(60)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const CornerHeaderContainer(
                      header: 'Portions', hasBackArrow: true),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SizedBox(
                      width: MyUtility(context).width * 0.90,
                      child: ListView.builder(
                        itemCount: _portions.length,
                        itemBuilder: (context, index) => _portions[index],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CommonButton(
                    textColor: MyColors().black,
                    buttonColor: MyColors().yellow,
                    customWidth: MyUtility(context).width * 0.90,
                    buttonText: 'Add Portion',
                    onTap: () async {
                      final newPortion = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewPortion()),
                      );
                      if (newPortion != null) {
                        _addPortion(newPortion['portionName'],
                            newPortion['rowLength'], newPortion['portionType']);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
