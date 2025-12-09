import 'package:flutter/material.dart';
import '../theme/manga_theme.dart';
import '../models/study_content.dart';
import '../widgets/manga_effects.dart';

/// ✨ THE MOST DRIPPED-OUT MANGA CARD YOU HAVE EVER SEEN ✨
class UltraMangaCard extends StatelessWidget {
  final Module module;
  final double progress;
  final int completedTopics;
  final int totalTopics;
  final VoidCallback onTap;

  const UltraMangaCard({
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

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 🔥 BOOM! Explosion manga background
          Positioned.fill(
            child: CustomPaint(
              painter: ActionBurstPainter(
                color: isComplete
                    ? MangaTheme.highlightYellow.withOpacity(0.4)
                    : MangaTheme.speedlineBlue.withOpacity(0.15),
              ),
            ),
          ),

          // 🧱 Main card
          Container(
            margin: const EdgeInsets.only(bottom: 26),
            decoration: BoxDecoration(
              color: MangaTheme.paperWhite,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: MangaTheme.inkBlack,
                width: 5,
              ),
              boxShadow: [
                const BoxShadow(
                  color: MangaTheme.inkBlack,
                  offset: Offset(10, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  // ⚪ Halftone
                  Positioned.fill(
                    child: CustomPaint(
                      painter: HalftonePainter(
                        color: MangaTheme.inkBlack.withOpacity(0.05),
                        density: 13,
                      ),
                    ),
                  ),

                  // 💨 Speed lines (only if not complete)
                  if (!isComplete)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: SpeedEffectPainter(
                          color: MangaTheme.speedlineBlue.withOpacity(0.05),
                          isHorizontal: false,
                        ),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildBadge(context),
                            const SizedBox(width: 18),
                            Expanded(child: _buildModuleInfo(context)),
                          ],
                        ),

                        const SizedBox(height: 24),
                        _buildProgress(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🎉 "COMPLETE!!" Sticker
          if (isComplete)
            Positioned(
              top: -14,
              right: -10,
              child: Transform.rotate(
                angle: -0.2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: MangaTheme.mangaRed,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 4,
                      color: MangaTheme.inkBlack,
                    ),
                  ),
                  child: const Text(
                    "BAM! DONE!!",
                    style: TextStyle(
                      color: MangaTheme.paperWhite,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 🔴 Big Manga Badge
  Widget _buildBadge(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 8,
          top: 8,
          child: Container(
            width: 78,
            height: 78,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: MangaTheme.inkBlack,
            ),
          ),
        ),
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: progress == 1 ? MangaTheme.highlightYellow : MangaTheme.mangaRed,
            border: Border.all(color: MangaTheme.inkBlack, width: 5),
            boxShadow: [
              BoxShadow(
                color: MangaTheme.inkBlack.withOpacity(0.25),
                blurRadius: 0,
                offset: const Offset(4, 4),
              )
            ],
          ),
          child: Center(
            child: Text(
              module.id.toString(),
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: MangaTheme.inkBlack,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 📝 Module Info + Roasting Subtitle
  Widget _buildModuleInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          module.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: MangaTheme.inkBlack,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: progress == 1
                ? MangaTheme.highlightYellow.withOpacity(0.35)
                : MangaTheme.speedlineBlue.withOpacity(0.25),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: MangaTheme.inkBlack,
              width: 2,
            ),
          ),
          child: Text(
            _getRoastLine(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            _buildChip("$completedTopics/$totalTopics TOPICS"),
            if (progress == 1) _buildChip("ABSOLUTE UNIT"),
          ],
        )
      ],
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: MangaTheme.accentOrange.withOpacity(0.25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 2, color: MangaTheme.inkBlack),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: MangaTheme.inkBlack,
        ),
      ),
    );
  }

  // 📊 **Progress Bar With Holographic Manga Texture**
  Widget _buildProgress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "PROGRESS • ${(progress * 100).toInt()}%",
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: MangaTheme.inkBlack,
          ),
        ),
        const SizedBox(height: 10),

        Stack(
          children: [
            Container(
              height: 18,
              decoration: BoxDecoration(
                color: MangaTheme.panelGray,
                border: Border.all(
                  width: 3,
                  color: MangaTheme.inkBlack,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            FractionallySizedBox(
              widthFactor: progress,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 18,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: progress == 1
                          ? [
                              MangaTheme.highlightYellow,
                              MangaTheme.accentOrange,
                              MangaTheme.mangaRed,
                            ]
                          : [
                              MangaTheme.mangaRed,
                              MangaTheme.accentOrange,
                            ],
                    ),
                  ),
                  child: CustomPaint(
                    painter: ScreentonePainter(
                      color: MangaTheme.inkBlack.withOpacity(0.3),
                      angle: -40,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  // 🔥 New roast messages (funny)
  String _getRoastLine() {
    if (progress == 0) return "Bro hasn't even touched it 💀";
    if (progress < 0.2) return "Studying? More like procrastinating.exe";
    if (progress < 0.4) return "Ok ok, tiny baby progress. Proud-ish.";
    if (progress < 0.6) return "Midway! Don't stop now, lunchbox hero.";
    if (progress < 0.9) return "Almost done—just fight the final boss.";
    return "Certified Giga-Chad Scholar 🗿🔥";
  }
}
