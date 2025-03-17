import 'package:farming_gods_way/Constants/colors.dart';
import 'package:flutter/material.dart';

class CounterWidget extends StatelessWidget {
  final int count;
  final ValueChanged<int> onChanged;

  CounterWidget({required this.count, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors().black,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton("-", () {
            if (count > 0) {
              onChanged(count - 1);
            }
          }),
          Container(
            width: 40,
            padding: EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            color: MyColors().offWhite,
            child: Text(
              count.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          _buildButton("+", () {
            onChanged(count + 1);
          }),
        ],
      ),
    );
  }

  Widget _buildButton(String symbol, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Text(
          symbol,
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}