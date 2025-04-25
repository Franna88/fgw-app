import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../Constants/colors.dart';

class ModernCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool animate;
  final VoidCallback? onTap;
  final BoxShadow? customShadow;

  const ModernCard({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.color,
    this.padding,
    this.borderRadius,
    this.animate = true,
    this.onTap,
    this.customShadow,
  });

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    final card = Container(
      height: height,
      width: width,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? myColors.offWhite,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        boxShadow: [
          customShadow ?? BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    final tapWrapper = onTap != null
        ? InkWell(
            onTap: onTap,
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            child: card,
          )
        : card;

    return animate
        ? tapWrapper.animate().fadeIn(duration: 400.ms).slideY(
              begin: 0.1,
              end: 0,
              curve: Curves.easeOutQuad,
              duration: 400.ms,
            )
        : tapWrapper;
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? cardColor;
  final VoidCallback? onTap;
  
  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    this.cardColor,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    return ModernCard(
      onTap: onTap,
      color: cardColor ?? myColors.offWhite,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (iconColor ?? myColors.forestGreen).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor ?? myColors.forestGreen,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
} 