import 'package:flutter/material.dart';
import '../theme/manga_theme.dart';

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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: isCompleted
            ? MangaTheme.completedPanelDecoration()
            : MangaTheme.mangaPanelDecoration(hasAction: hasAction),
        child: child,
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
            Text(
              text,
              style: Theme.of(context).textTheme.labelLarge,
            ),
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
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
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
      path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(20),
      ));
    } else {
      // Speech bubble with tail
      path.moveTo(20, 0);
      path.lineTo(size.width - 20, 0);
      path.quadraticBezierTo(size.width, 0, size.width, 20);
      path.lineTo(size.width, size.height - 20);
      path.quadraticBezierTo(
          size.width, size.height, size.width - 20, size.height);
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

  const SpeedLine({
    super.key,
    required this.child,
    this.isAnimating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isAnimating)
          Positioned.fill(
            child: CustomPaint(
              painter: _SpeedLinePainter(),
            ),
          ),
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
          label,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 30,
              decoration: BoxDecoration(
                color: MangaTheme.panelGray,
                border: Border.all(
                  color: MangaTheme.primaryBlack,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              height: 30,
              width: MediaQuery.of(context).size.width * progress,
              decoration: BoxDecoration(
                color: MangaTheme.mangaRed,
                border: Border.all(
                  color: MangaTheme.inkBlack,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              height: 30,
              alignment: Alignment.center,
              child: Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: progress > 0.3
                          ? MangaTheme.paperWhite
                          : MangaTheme.primaryBlack,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: MangaTheme.inkBlack,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: MangaTheme.inkBlack.withOpacity(0.3),
            offset: const Offset(2, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: MangaTheme.paperWhite,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
