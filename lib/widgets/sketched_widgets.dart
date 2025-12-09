import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/manga_theme.dart';

/// A widget that wraps content with a hand-drawn manga-style sketched border
class SketchedBox extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final Color backgroundColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;

  const SketchedBox({
    super.key,
    required this.child,
    this.borderColor = MangaTheme.inkBlack,
    this.backgroundColor = MangaTheme.paperWhite,
    this.borderWidth = 4.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SketchedBoxPainter(
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        borderWidth: borderWidth,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(borderWidth + 8),
        child: child,
      ),
    );
  }
}

class _SketchedBoxPainter extends CustomPainter {
  final Color borderColor;
  final Color backgroundColor;
  final double borderWidth;

  _SketchedBoxPainter({
    required this.borderColor,
    required this.backgroundColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Fill background
    final fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(4),
    );
    canvas.drawRRect(rect, fillPaint);

    // Draw sketchy border
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Create path with slight randomness for hand-drawn effect
    final path = Path();
    final random = math.Random(42); // Fixed seed for consistency

    // Top edge
    path.moveTo(4, 0);
    for (double x = 10; x < size.width - 4; x += 15) {
      final wobble = (random.nextDouble() - 0.5) * 1.5;
      path.lineTo(x, wobble);
    }
    path.lineTo(size.width - 4, 0);

    // Right edge
    for (double y = 10; y < size.height - 4; y += 15) {
      final wobble = (random.nextDouble() - 0.5) * 1.5;
      path.lineTo(size.width + wobble, y);
    }
    path.lineTo(size.width, size.height - 4);

    // Bottom edge
    for (double x = size.width - 10; x > 4; x -= 15) {
      final wobble = (random.nextDouble() - 0.5) * 1.5;
      path.lineTo(x, size.height + wobble);
    }
    path.lineTo(4, size.height);

    // Left edge
    for (double y = size.height - 10; y > 4; y -= 15) {
      final wobble = (random.nextDouble() - 0.5) * 1.5;
      path.lineTo(wobble, y);
    }
    path.close();

    canvas.drawPath(path, borderPaint);

    // Draw shadow
    final shadowPath = Path();
    shadowPath.moveTo(6 + 4, 6);
    shadowPath.lineTo(size.width + 6, 6);
    shadowPath.lineTo(size.width + 6, size.height + 6 - 4);
    shadowPath.lineTo(size.width, size.height + 6);
    shadowPath.lineTo(6, size.height + 6);
    shadowPath.lineTo(6, 6 + 4);
    shadowPath.close();

    final shadowPaint = Paint()
      ..color = borderColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawPath(shadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Comic-style text emphasis with action lines
class ActionText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const ActionText({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Action lines background
        Positioned.fill(child: CustomPaint(painter: _ActionLinesPainter())),
        // Text with outline
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Text(
            text.toUpperCase(),
            style: (style ?? Theme.of(context).textTheme.displayMedium)
                ?.copyWith(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3
                    ..color = MangaTheme.inkBlack,
                  letterSpacing: 2,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Text(
            text.toUpperCase(),
            style: (style ?? Theme.of(context).textTheme.displayMedium)
                ?.copyWith(
                  color: MangaTheme.paperWhite,
                  letterSpacing: 2,
                  shadows: [
                    const Shadow(
                      color: MangaTheme.highlightYellow,
                      offset: Offset(0, 0),
                      blurRadius: 8,
                    ),
                  ],
                ),
          ),
        ),
      ],
    );
  }
}

class _ActionLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MangaTheme.highlightYellow.withOpacity(0.3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      final startX = size.width * 0.1 + i * 5;
      final endX = size.width * 0.9 + i * 5;
      canvas.drawLine(Offset(startX, 0), Offset(endX, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
