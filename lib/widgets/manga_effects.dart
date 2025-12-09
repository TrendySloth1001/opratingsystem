import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/manga_theme.dart';

// Halftone dot pattern painter for manga effect
class HalftonePainter extends CustomPainter {
  final Color color;
  final double density;

  HalftonePainter({required this.color, this.density = 8.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += density) {
      for (double y = 0; y < size.height; y += density) {
        final dotSize = 1.5 + (x + y) % 3;
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Sketch line effect for borders
class SketchBorderPainter extends CustomPainter {
  final Color color;
  final double thickness;

  SketchBorderPainter({required this.color, this.thickness = 4.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Top line with slight wobble
    path.moveTo(0, 0);
    for (double x = 0; x < size.width; x += 10) {
      final wobble = math.sin(x / 20) * 0.5;
      path.lineTo(x, wobble);
    }
    path.lineTo(size.width, 0);

    // Right line
    for (double y = 0; y < size.height; y += 10) {
      final wobble = math.cos(y / 20) * 0.5;
      path.lineTo(size.width + wobble, y);
    }
    path.lineTo(size.width, size.height);

    // Bottom line
    for (double x = size.width; x > 0; x -= 10) {
      final wobble = math.sin(x / 20) * 0.5;
      path.lineTo(x, size.height + wobble);
    }
    path.lineTo(0, size.height);

    // Left line
    for (double y = size.height; y > 0; y -= 10) {
      final wobble = math.cos(y / 20) * 0.5;
      path.lineTo(wobble, y);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Action burst effect
class ActionBurstPainter extends CustomPainter {
  final Color color;
  final double intensity;

  ActionBurstPainter({required this.color, this.intensity = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < 16; i++) {
      final angle = (i * 22.5) * math.pi / 180;
      final startRadius = 20.0;
      final endRadius = math.min(size.width, size.height) / 2;

      canvas.drawLine(
        Offset(
          centerX + startRadius * math.cos(angle),
          centerY + startRadius * math.sin(angle),
        ),
        Offset(
          centerX + endRadius * math.cos(angle),
          centerY + endRadius * math.sin(angle),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Comic style text background
class ComicTextBackgroundPainter extends CustomPainter {
  final Color color;

  ComicTextBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = MangaTheme.inkBlack
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Create jagged comic book style background
    final path = Path();
    path.moveTo(5, 0);
    path.lineTo(size.width - 5, 0);
    path.lineTo(size.width, 5);
    path.lineTo(size.width, size.height - 5);
    path.lineTo(size.width - 5, size.height);
    path.lineTo(5, size.height);
    path.lineTo(0, size.height - 5);
    path.lineTo(0, 5);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);

    // Add accent lines
    final accentPaint = Paint()
      ..color = MangaTheme.inkBlack.withOpacity(0.1)
      ..strokeWidth = 1;

    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(10 + i * 5, 0),
        Offset(20 + i * 5, size.height),
        accentPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Speed effect for emphasis
class SpeedEffectPainter extends CustomPainter {
  final Color color;
  final bool isHorizontal;

  SpeedEffectPainter({required this.color, this.isHorizontal = true});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (isHorizontal) {
      for (int i = 0; i < 8; i++) {
        final y = (i + 1) * (size.height / 9);
        final startX = size.width * 0.1;
        final endX = size.width * 0.9;

        canvas.drawLine(
          Offset(startX, y),
          Offset(endX, y + (i % 2 == 0 ? 2 : -2)),
          paint,
        );
      }
    } else {
      for (int i = 0; i < 8; i++) {
        final x = (i + 1) * (size.width / 9);
        final startY = size.height * 0.1;
        final endY = size.height * 0.9;

        canvas.drawLine(
          Offset(x, startY),
          Offset(x + (i % 2 == 0 ? 2 : -2), endY),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Screentone effect (common in manga)
class ScreentonePainter extends CustomPainter {
  final Color color;
  final double angle;

  ScreentonePainter({required this.color, this.angle = 45.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angle * math.pi / 180);
    canvas.translate(-size.width / 2, -size.height / 2);

    for (double i = -size.width; i < size.width * 2; i += 4) {
      canvas.drawLine(
        Offset(i, -size.height),
        Offset(i, size.height * 2),
        paint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
