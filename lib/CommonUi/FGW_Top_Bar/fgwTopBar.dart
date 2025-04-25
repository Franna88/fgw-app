import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/LandingPage/ui/myBurgerMenuPage.dart';
import 'package:farming_gods_way/Messages/Messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Constants/colors.dart';
import 'circleButtons.dart';

class FgwTopBar extends StatefulWidget {
  final String? title;
  
  const FgwTopBar({
    super.key,
    this.title,
  });

  @override
  State<FgwTopBar> createState() => _FgwTopBarState();
}

class _FgwTopBarState extends State<FgwTopBar> {
  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Container(
      width: MyUtility(context).width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: myColors.forestGreen,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo with updated design
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: myColors.offWhite,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.seedling,
                color: myColors.forestGreen,
                size: 22,
              ),
            ),
          ),
          
          // Title if provided
          if (widget.title != null) ...[
            const SizedBox(width: 16),
            Text(
              widget.title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1, end: 0),
          ],
          
          const Spacer(),
          
          // Buttons with improved design
          Row(
            children: [
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
              const SizedBox(width: 12),
              CircleButtons(
                hasNotification: true,
                icon: Icons.notifications_active_outlined,
                onTap: () {
                  //TODO: Implement notifications page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications coming soon')),
                  );
                },
              ),
              const SizedBox(width: 12),
              CircleButtons(
                hasNotification: false,
                icon: Icons.menu,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyBurgerMenuPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
