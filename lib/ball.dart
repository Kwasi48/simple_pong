import 'package:flutter/material.dart';


class Ball extends StatelessWidget {
  const Ball({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double diameter = 50;
    return Container(
      width: diameter,
      height: diameter,
      decoration: new BoxDecoration(
        color: Colors.amber[400],
        shape: BoxShape.circle
      ),
    );
  }
}
