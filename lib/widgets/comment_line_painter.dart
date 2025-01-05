import 'package:flutter/material.dart';

class CommentLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Vẽ đường dọc
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );

    // Vẽ đường cong ngang
    final path = Path();
    path.moveTo(size.width / 2, size.height * 0.2);  // Bắt đầu từ đường dọc
    path.lineTo(size.width, size.height * 0.2);       // Kéo ngang đến comment

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
