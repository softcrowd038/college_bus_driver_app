import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text1;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  const TextWidget(
      {super.key,
      required this.text1,
      required this.fontWeight,
      required this.color,
      required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text1,
      style:
          TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
