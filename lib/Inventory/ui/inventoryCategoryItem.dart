import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InventoryCategoryItem extends StatefulWidget {
  final bool styleOne;
  final String image;
  final String name;
  final Function() onTap;
  
  const InventoryCategoryItem({
    super.key,
    required this.styleOne,
    required this.image,
    required this.name,
    required this.onTap
  });

  @override
  State<InventoryCategoryItem> createState() => _InventoryCategoryItemState();
}

class _InventoryCategoryItemState extends State<InventoryCategoryItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final myColors = MyColors();
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: InkWell(
        onTap: widget.onTap,
        onHover: (hover) {
          setState(() {
            _isHovered = hover;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.05),
                blurRadius: _isHovered ? 8 : 4,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(
              color: _isHovered 
                ? (widget.styleOne ? myColors.green : myColors.yellow) 
                : Colors.grey[200]!,
              width: _isHovered ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: ShapeDecoration(
                    shadows: [
                      BoxShadow(
                        offset: const Offset(0, 2),
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                      ),
                    ],
                    color: widget.styleOne ? myColors.green : myColors.yellow,
                    image: DecorationImage(
                      image: AssetImage(widget.image),
                      fit: BoxFit.scaleDown,
                    ),
                    shape: const CircleBorder(),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    widget.name,
                    style: GoogleFonts.robotoSlab(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
