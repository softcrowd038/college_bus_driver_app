import 'package:flutter/material.dart';

class CustomColorContainer extends StatelessWidget {
  final Color color1;
  final Color color2;
  const CustomColorContainer(
      {super.key, required this.color1, required this.color2});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color1,
            color2,
          ],
        ),
      ),
    );
  }
}
