import 'package:flutter/material.dart';
import '../theme/manga_theme.dart';
import '../models/study_content.dart';
import '../widgets/manga_effects.dart';

/// Enhanced Module Card with Manga Background Effects
class MangaModuleCard extends StatelessWidget {
  final Module module;
  final double progress;
  final int completedTopics;
  final int totalTopics;
  final VoidCallback onTap;

  const MangaModuleCard({
    super.key,
    required this.module,
    required this.progress,
    required this.completedTopics,
    required this.totalTopics,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = progress == 1.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Manga action burst background
            if (isComplete)
              Positioned(
                top: -10,
                left: -10,
                right: -10,
                bottom: -10,
                child: CustomPaint(
                  painter: ActionBurstPainter(
                    color: MangaTheme.highlightYellow,
                  ),
                ),
              ),
            // Main card container
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isComplete
                      ? [
                          MangaTheme.highlightYellow.withOpacity(0.2),
                          MangaTheme.paperWhite,
                        ]
                      : [
                          MangaTheme.paperWhite,
                          MangaTheme.panelGray.withOpacity(0.3),
                        ],
                ),
                border: Border.all(
                  color: MangaTheme.inkBlack,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: MangaTheme.inkBlack,
                    offset: const Offset(8, 8),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    // Halftone pattern overlay
                    Positioned.fill(
                      child: CustomPaint(
                        painter: HalftonePainter(
                          color: MangaTheme.inkBlack.withOpacity(0.05),
                          density: 15,
                        ),
                      ),
                    ),
                    // Speed lines effect for incomplete modules
                    if (!isComplete)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: SpeedEffectPainter(
                            color: MangaTheme.speedlineBlue.withOpacity(0.03),
                            isHorizontal: true,
                          ),
                        ),
                      ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Enhanced module number badge
                              _buildModuleNumberBadge(context, isComplete),
                              const SizedBox(width: 20),
                              // Module info
                              Expanded(
                                child: _buildModuleInfo(context, isComplete),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Progress section
                          _buildProgressSection(isComplete),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // "COMPLETE!" sticker for finished modules
            if (isComplete)
              Positioned(
                top: -8,
                right: -8,
                child: Transform.rotate(
                  angle: 0.2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: MangaTheme.mangaRed,
                      border: Border.all(
                        color: MangaTheme.inkBlack,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: MangaTheme.inkBlack,
                          offset: const Offset(4, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: const Text(
                      'COMPLETE!',
                      style: TextStyle(
                        color: MangaTheme.paperWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleNumberBadge(BuildContext context, bool isComplete) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Shadow layer
        Positioned(
          left: 6,
          top: 6,
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: MangaTheme.inkBlack,
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Main badge
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isComplete
                ? MangaTheme.highlightYellow
                : MangaTheme.mangaRed,
            border: Border.all(
              color: MangaTheme.inkBlack,
              width: 5,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isComplete
                        ? MangaTheme.highlightYellow
                        : MangaTheme.mangaRed)
                    .withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Inner circle for depth
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: MangaTheme.inkBlack.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                ),
              ),
              // Module number
              Center(
                child: Text(
                  '${module.id}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: MangaTheme.inkBlack,
                    shadows: [
                      Shadow(
                        color: MangaTheme.paperWhite.withOpacity(0.8),
                        offset: const Offset(2, 2),
                        blurRadius: 0,
                      ),
                      Shadow(
                        color: MangaTheme.paperWhite.withOpacity(0.5),
                        offset: const Offset(-1, -1),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Manga flash effect lines for completed
        if (isComplete)
          Positioned(
            top: -5,
            left: -5,
            right: -5,
            bottom: -5,
            child: CustomPaint(
              painter: _FlashLinesPainter(),
            ),
          ),
      ],
    );
  }

  Widget _buildModuleInfo(BuildContext context, bool isComplete) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Module title with manga font effect
        Text(
          module.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: MangaTheme.inkBlack,
            height: 1.2,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        // Status/roast message
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isComplete
                ? MangaTheme.highlightYellow.withOpacity(0.3)
                : MangaTheme.speedlineBlue.withOpacity(0.2),
            border: Border.all(
              color: MangaTheme.inkBlack,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            _getRoastMessage(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: MangaTheme.inkBlack,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Topic badges
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildBadge(
              '$completedTopics/$totalTopics TOPICS',
              isComplete
                  ? MangaTheme.accentOrange
                  : MangaTheme.speedlineBlue,
            ),
            if (isComplete)
              _buildBadge(
                '100% DONE!',
                MangaTheme.highlightYellow,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        border: Border.all(
          color: MangaTheme.inkBlack,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: MangaTheme.inkBlack.withOpacity(0.2),
            offset: const Offset(2, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: MangaTheme.inkBlack,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildProgressSection(bool isComplete) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'PROGRESS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: MangaTheme.inkBlack,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: isComplete
                    ? MangaTheme.highlightYellow
                    : MangaTheme.mangaRed,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Manga-style progress bar
        Stack(
          children: [
            // Background
            Container(
              height: 16,
              decoration: BoxDecoration(
                color: MangaTheme.panelGray,
                border: Border.all(
                  color: MangaTheme.inkBlack,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            // Progress fill with pattern
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 16,
                width: double.infinity,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isComplete
                            ? [
                                MangaTheme.highlightYellow,
                                MangaTheme.accentOrange,
                              ]
                            : [
                                MangaTheme.mangaRed,
                                MangaTheme.accentOrange,
                              ],
                      ),
                      border: Border.all(
                        color: MangaTheme.inkBlack,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: CustomPaint(
                      painter: ScreentonePainter(
                        color: MangaTheme.inkBlack.withOpacity(0.3),
                        angle: 45,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getRoastMessage() {
    if (progress == 0) {
      return "Haven't even started? Brave.";
    } else if (progress < 0.3) {
      return "Baby steps... very baby steps.";
    } else if (progress < 0.5) {
      return "Getting somewhere... slowly.";
    } else if (progress < 0.7) {
      return "Halfway! Don't give up now!";
    } else if (progress < 1.0) {
      return "SO CLOSE! Finish strong!";
    } else {
      return "LEGEND STATUS UNLOCKED!";
    }
  }
}

/// Custom painter for flash lines around completed badge
class _FlashLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MangaTheme.highlightYellow
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw flash lines radiating from badge
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final startX = center.dx + radius * 0.8 * (i % 2 == 0 ? 1 : 0.9) * 
          (i % 2 == 0 ? 1.1 : 1) * (i.isEven ? 1 : 0.85);
      final startY = center.dy + radius * 0.8 * (i % 2 == 0 ? 1 : 0.9) * 
          (i % 2 == 0 ? 1.1 : 1) * (i.isEven ? 1 : 0.85);
      final endX = center.dx + radius * 1.3 * (i % 2 == 0 ? 1 : 0.95) * 
          (i % 2 == 0 ? 1.15 : 1);
      final endY = center.dy + radius * 1.3 * (i % 2 == 0 ? 1 : 0.95) * 
          (i % 2 == 0 ? 1.15 : 1);

      canvas.drawLine(
        Offset(
          center.dx + (startX - center.dx) * (angle / 3.14159).abs(),
          center.dy + (startY - center.dy) * (angle / 3.14159).abs(),
        ),
        Offset(
          center.dx + (endX - center.dx) * (angle / 3.14159).abs(),
          center.dy + (endY - center.dy) * (angle / 3.14159).abs(),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
