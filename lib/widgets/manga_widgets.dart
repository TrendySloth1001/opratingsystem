import 'package:flutter/material.dart';
import '../theme/manga_theme.dart';
import 'manga_effects.dart';

class MangaPanel extends StatelessWidget {
  final Widget child;
  final bool isCompleted;
  final bool hasAction;
  final VoidCallback? onTap;

  const MangaPanel({
    super.key,
    required this.child,
    this.isCompleted = false,
    this.hasAction = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Base container with decoration
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: isCompleted
                ? MangaTheme.completedPanelDecoration()
                : MangaTheme.mangaPanelDecoration(hasAction: hasAction),
            child: child,
          ),
          // Halftone effect overlay for texture
          if (isCompleted)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: HalftonePainter(
                    color: MangaTheme.highlightYellow.withOpacity(0.1),
                    density: 12,
                  ),
                ),
              ),
            ),
          // Speed lines for action panels
          if (hasAction && !isCompleted)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: SpeedEffectPainter(
                    color: MangaTheme.mangaRed.withOpacity(0.08),
                    isHorizontal: true,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MangaActionBubble extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;

  const MangaActionBubble({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: MangaTheme.actionPanelDecoration(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: MangaTheme.paperWhite, size: 20),
              const SizedBox(width: 8),
            ],
            Text(text, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

class MangaSpeechBubble extends StatelessWidget {
  final String text;
  final bool isThought;

  const MangaSpeechBubble({
    super.key,
    required this.text,
    this.isThought = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpeechBubblePainter(isThought: isThought),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}

class _SpeechBubblePainter extends CustomPainter {
  final bool isThought;

  _SpeechBubblePainter({this.isThought = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MangaTheme.paperWhite
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = MangaTheme.primaryBlack
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();
    if (isThought) {
      // Cloud-like thought bubble
      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(20),
        ),
      );
    } else {
      // Speech bubble with tail
      path.moveTo(20, 0);
      path.lineTo(size.width - 20, 0);
      path.quadraticBezierTo(size.width, 0, size.width, 20);
      path.lineTo(size.width, size.height - 20);
      path.quadraticBezierTo(
        size.width,
        size.height,
        size.width - 20,
        size.height,
      );
      path.lineTo(40, size.height);
      path.lineTo(20, size.height + 10);
      path.lineTo(30, size.height);
      path.lineTo(20, size.height);
      path.quadraticBezierTo(0, size.height, 0, size.height - 20);
      path.lineTo(0, 20);
      path.quadraticBezierTo(0, 0, 20, 0);
    }

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SpeedLine extends StatelessWidget {
  final Widget child;
  final bool isAnimating;

  const SpeedLine({super.key, required this.child, this.isAnimating = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isAnimating)
          Positioned.fill(child: CustomPaint(painter: _SpeedLinePainter())),
        child,
      ],
    );
  }
}

class _SpeedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MangaTheme.primaryBlack.withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 10; i++) {
      final y = size.height * (i / 10);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width * 0.3, y + size.height * 0.05),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MangaProgressBar extends StatelessWidget {
  final double progress;
  final String label;

  const MangaProgressBar({
    super.key,
    required this.progress,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                color: MangaTheme.primaryBlack.withOpacity(0.3),
                offset: const Offset(2, 2),
                blurRadius: 0,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            // Background with texture
            Container(
              height: 36,
              decoration: BoxDecoration(
                color: MangaTheme.panelGray,
                border: Border.all(color: MangaTheme.primaryBlack, width: 4),
                borderRadius: BorderRadius.circular(2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: CustomPaint(
                  painter: ScreentonePainter(
                    color: MangaTheme.primaryBlack.withOpacity(0.05),
                    angle: 45,
                  ),
                ),
              ),
            ),
            // Progress fill
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              height: 36,
              width: MediaQuery.of(context).size.width * progress,
              decoration: BoxDecoration(
                color: MangaTheme.mangaRed,
                border: Border.all(color: MangaTheme.inkBlack, width: 4),
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: MangaTheme.mangaRed.withOpacity(0.5),
                    offset: const Offset(0, 0),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: CustomPaint(
                  painter: SpeedEffectPainter(
                    color: MangaTheme.paperWhite.withOpacity(0.2),
                    isHorizontal: true,
                  ),
                ),
              ),
            ),
            Container(
              height: 36,
              alignment: Alignment.center,
              child: Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: 1,
                  color: progress > 0.3
                      ? MangaTheme.paperWhite
                      : MangaTheme.primaryBlack,
                  shadows: [
                    Shadow(
                      color: progress > 0.3
                          ? MangaTheme.inkBlack
                          : MangaTheme.paperWhite,
                      offset: const Offset(2, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MangaBadge extends StatelessWidget {
  final String text;
  final Color color;

  const MangaBadge({
    super.key,
    required this.text,
    this.color = MangaTheme.mangaRed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Shadow layer
        Positioned(
          left: 3,
          top: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: MangaTheme.inkBlack,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.transparent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Main badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: MangaTheme.inkBlack, width: 3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: MangaTheme.paperWhite,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: MangaTheme.inkBlack,
                  offset: const Offset(1, 1),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
