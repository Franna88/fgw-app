import 'package:farming_gods_way/CommonUi/FGW_Top_Bar/circleButtons.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/LandingPage/ui/myBurgerMenuPage.dart';
import 'package:farming_gods_way/Messages/Messages.dart';
import 'package:flutter/material.dart';

import '../../Constants/colors.dart';

class FgwTopBar extends StatefulWidget {
  const FgwTopBar({super.key});

  @override
  State<FgwTopBar> createState() => _FgwTopBarState();
}

class _FgwTopBarState extends State<FgwTopBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MyUtility(context).width,
      height: 80,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            color: MyColors().black,
            child: const Center(
              child: Text(
                'logo',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(),
          CircleButtons(
            icon: Icons.mail_outline,
            hasNotification: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Messages()),
              );
            },
          ),
          const SizedBox(
            width: 20,
          ),
          CircleButtons(
            hasNotification: true,
            icon: Icons.notifications_active_outlined,
            onTap: () {
              //TO DO NOTIFICATIONS
            },
          ),
          const SizedBox(
            width: 20,
          ),
          CircleButtons(
            hasNotification: false,
            icon: Icons.menu,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyBurgerMenuPage()),
              );
            },
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
