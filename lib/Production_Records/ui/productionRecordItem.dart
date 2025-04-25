import 'package:farming_gods_way/Constants/colors.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductionRecordItem extends StatefulWidget {
  final String date;
  final String product;
  final String productQuantity;
  
  const ProductionRecordItem({
    super.key,
    required this.date,
    required this.product,
    required this.productQuantity,
  });

  @override
  State<ProductionRecordItem> createState() => _ProductionRecordItemState();
}

class _ProductionRecordItemState extends State<ProductionRecordItem> {
  late Color productColor;
  late IconData productIcon;

  @override
  void initState() {
    super.initState();
    _setProductDetails();
  }

  void _setProductDetails() {
    // Set color and icon based on product type
    switch (widget.product.toLowerCase()) {
      case 'tomatoes':
        productColor = Colors.red[600]!;
        productIcon = FontAwesomeIcons.apple;
        break;
      case 'carrots':
        productColor = Colors.orange;
        productIcon = FontAwesomeIcons.carrot;
        break;
      case 'beetroot':
        productColor = Colors.purple[700]!;
        productIcon = FontAwesomeIcons.seedling;
        break;
      case 'potatoes':
        productColor = Colors.brown[600]!;
        productIcon = FontAwesomeIcons.circleStop;
        break;
      case 'cabbage':
        productColor = Colors.green[600]!;
        productIcon = FontAwesomeIcons.leaf;
        break;
      default:
        productColor = MyColors().forestGreen;
        productIcon = FontAwesomeIcons.plantWilt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: MyColors().forestGreen,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.date,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Harvest',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Product icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: productColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    productIcon,
                    color: productColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total Harvested',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Quantity
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    widget.productQuantity,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: productColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
