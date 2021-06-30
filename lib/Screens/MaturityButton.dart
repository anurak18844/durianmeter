import 'package:flutter/material.dart';

class MaturityButton extends StatelessWidget {
  final int maturityScore;
  final Color color;
  final VoidCallback onPress;
  MaturityButton({
      required this.maturityScore,
      required this.color,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    String strMaturityScore = "$maturityScore%";
    return Container(
      height: 70.0,
      width: 65.0,
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        onPressed: () {
          this.onPress();
        },
        child: Text(
          strMaturityScore,
          style: TextStyle(fontSize: 13.5, color: Colors.black),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color?>(this.color),
        ),
      ),
    );
  }
}
