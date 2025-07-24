import 'package:flutter/material.dart';

class CustomContainer extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, 30);
    path.quadraticBezierTo(size.width / 2, -20, size.width, 30);
    path.lineTo(size.width, 30);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
