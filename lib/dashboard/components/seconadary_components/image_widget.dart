import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String icon;
  final double? height;
  final double? width;
  const ImageWidget(
      {super.key,
      required this.icon,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(icon),
      height: height,
      width: width,
    );
  }
}
