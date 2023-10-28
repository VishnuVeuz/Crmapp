import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CustomShape extends CustomClipper<Path> {
  final double textWidth;

  CustomShape(this.textWidth);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width / 1.2, size.height);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 1.2, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
