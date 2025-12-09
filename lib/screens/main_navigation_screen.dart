import 'package:flutter/material.dart';
import '../theme/manga_theme.dart';
import 'home_screen.dart';
import 'syllabus_tracker_screen.dart';
import 'settings_screen.dart';

/// 🎮 MAIN NAVIGATION WITH BOTTOM BAR
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SyllabusTrackerScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: MangaTheme.paperWhite,
          border: const Border(
            top: BorderSide(
              color: MangaTheme.inkBlack,
              width: 5,
            ),
          ),
          boxShadow: const [
            BoxShadow(
              color: MangaTheme.inkBlack,
              offset: Offset(0, -6),
              blurRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMangaNavButton(0, Icons.quiz_rounded, 'PYQ'),
                _buildMangaNavButton(1, Icons.menu_book_rounded, 'MODULES'),
                _buildMangaNavButton(2, Icons.analytics_rounded, 'STATS'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMangaNavButton(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? MangaTheme.mangaRed
                : MangaTheme.paperWhite,
            border: Border.all(
              color: MangaTheme.inkBlack,
              width: isSelected ? 4 : 3,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: MangaTheme.inkBlack,
                      offset: Offset(5, 5),
                      blurRadius: 0,
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: MangaTheme.inkBlack,
                      offset: Offset(2, 2),
                      blurRadius: 0,
                    ),
                  ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Action burst effect for selected tab
                  if (isSelected)
                    CustomPaint(
                      size: const Size(50, 50),
                      painter: _ActionBurstPainter(),
                    ),
                  Icon(
                    icon,
                    size: 24,
                    color: isSelected
                        ? MangaTheme.paperWhite
                        : MangaTheme.inkBlack,
                    weight: isSelected ? 700 : 400,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? MangaTheme.paperWhite
                      : MangaTheme.inkBlack,
                  fontWeight: FontWeight.w900,
                  fontSize: 9,
                  letterSpacing: 1.2,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 💥 Custom painter for manga-style action burst effect
class _ActionBurstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MangaTheme.highlightYellow.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw 8 burst lines radiating from center
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159265359 / 180);
      final path = Path();
      
      // Create star burst effect with varying lengths
      final burstLength = radius * (0.7 + 0.2 * (i % 2));
      
      path.moveTo(center.dx, center.dy);
      path.lineTo(
        center.dx + burstLength * _cos(angle - 0.15),
        center.dy + burstLength * _sin(angle - 0.15),
      );
      path.lineTo(
        center.dx + (radius * 0.9) * _cos(angle),
        center.dy + (radius * 0.9) * _sin(angle),
      );
      path.lineTo(
        center.dx + burstLength * _cos(angle + 0.15),
        center.dy + burstLength * _sin(angle + 0.15),
      );
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  double _cos(double radians) {
    // Taylor series approximation for cosine
    double result = 1.0;
    double term = 1.0;
    for (int n = 1; n <= 10; n++) {
      term *= -radians * radians / ((2 * n - 1) * (2 * n));
      result += term;
    }
    return result;
  }

  double _sin(double radians) {
    // Taylor series approximation for sine
    double result = radians;
    double term = radians;
    for (int n = 1; n <= 10; n++) {
      term *= -radians * radians / ((2 * n) * (2 * n + 1));
      result += term;
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
