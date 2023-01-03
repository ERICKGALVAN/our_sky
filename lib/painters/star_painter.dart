import 'package:flutter/material.dart';

import '../models/star_model.dart';

class StarPainter extends CustomPainter {
  final List<StarModel>? stars;
  final double? animationValue;

  StarPainter({this.stars, this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (var star in stars!) {
      canvas.drawCircle(
        Offset(star.positionX, star.positionY + animationValue! * star.speed),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
