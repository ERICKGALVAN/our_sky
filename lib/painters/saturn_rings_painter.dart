import 'package:flutter/material.dart';

class SaturnRingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Crea un pincel con el color y el grosor deseado para los anillos
    final paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2;

    // Dibuja los anillos de Saturno utilizando el pincel y la API de dibujo de Canvas
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
