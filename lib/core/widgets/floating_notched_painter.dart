import 'package:flutter/material.dart';

class FloatingNotchedPainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  FloatingNotchedPainter({required this.color, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path();
    const double r = 16.0; // corner radius of floating bar
    const double notchRadius = 32.0; // radius of cutout notch (creating space gap around 48px circle)

    path.moveTo(r, 0);
    
    // Top edge with notch
    final double notchCenter = size.width / 2;
    path.lineTo(notchCenter - notchRadius - 8, 0);
    path.quadraticBezierTo(
      notchCenter - notchRadius,
      0,
      notchCenter - notchRadius,
      8,
    );
    path.arcToPoint(
      Offset(notchCenter + notchRadius, 8),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );
    path.quadraticBezierTo(
      notchCenter + notchRadius,
      0,
      notchCenter + notchRadius + 8,
      0,
    );
    path.lineTo(size.width - r, 0);
    
    // Top-right corner
    path.quadraticBezierTo(size.width, 0, size.width, r);
    path.lineTo(size.width, size.height - r);
    
    // Bottom-right corner
    path.quadraticBezierTo(size.width, size.height, size.width - r, size.height);
    path.lineTo(r, size.height);
    
    // Bottom-left corner
    path.quadraticBezierTo(0, size.height, 0, size.height - r);
    path.lineTo(0, r);
    
    // Top-left corner
    path.quadraticBezierTo(0, 0, r, 0);
    path.close();

    // Draw shadow
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.3), 8.0, true);
    
    // Fill and border
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
