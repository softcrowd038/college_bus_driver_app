import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final IconData? icon;
  final Color? color;
  final double? size;
  const IconWidget(
      {super.key, required this.icon, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
      size: size,
    );
  }
}
