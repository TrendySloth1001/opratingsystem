import 'package:flutter/material.dart';
import '../theme/manga_theme.dart';
import '../widgets/manga_effects.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _burstController;
  late AnimationController _bounceController;
  late AnimationController _textController;
  late Animation<double> _burstAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    _burstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _burstAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _burstController, curve: Curves.easeOut),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _burstController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _bounceController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 1800));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _burstController.dispose();
    _bounceController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MangaTheme.paperWhite,
      body: AnimatedBuilder(
        animation: Listenable.merge([_burstController, _bounceController, _textController]),
        builder: (context, child) {
          return Stack(
            children: [
              // 💥 Massive action burst background
              Positioned.fill(
                child: CustomPaint(
                  painter: ActionBurstPainter(
                    color: MangaTheme.mangaRed.withOpacity(_burstAnimation.value * 0.2),
                  ),
                ),
              ),
              
              // ⚪ Halftone dots everywhere
              Positioned.fill(
                child: CustomPaint(
                  painter: HalftonePainter(
                    color: MangaTheme.inkBlack.withOpacity(0.06),
                    density: 20,
                  ),
                ),
              ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🎯 MEGA LOGO with bounce
                    Transform.scale(
                      scale: _bounceAnimation.value,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Shadow
                          Positioned(
                            left: 12,
                            top: 12,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: const BoxDecoration(
                                color: MangaTheme.inkBlack,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          // Main circle
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  MangaTheme.mangaRed,
                                  MangaTheme.accentOrange,
                                ],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: MangaTheme.inkBlack,
                                width: 8,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: MangaTheme.mangaRed.withOpacity(0.6),
                                  blurRadius: 40,
                                  spreadRadius: 15,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'OS',
                                style: TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.w900,
                                  color: MangaTheme.paperWhite,
                                  shadows: [
                                    Shadow(
                                      color: MangaTheme.inkBlack,
                                      offset: Offset(3, 3),
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // 📝 Epic title with fade
                    Opacity(
                      opacity: _textAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - _textAnimation.value)),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: MangaTheme.inkBlack,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: MangaTheme.inkBlack,
                                  width: 4,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: MangaTheme.inkBlack,
                                    offset: Offset(6, 6),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: const Text(
                                'OPERATING SYSTEMS',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: MangaTheme.paperWhite,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            const Text(
                              'YOUR EXAM SURVIVAL GUIDE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MangaTheme.inkBlack,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            
                            const SizedBox(height: 40),
                            
                            // 🔥 Loading badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: MangaTheme.highlightYellow,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: MangaTheme.inkBlack,
                                  width: 3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: MangaTheme.inkBlack,
                                    offset: Offset(4, 4),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '⚡',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'LOADING POWER MODE',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: MangaTheme.inkBlack,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '⚡',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 💬 Funny roast at bottom
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: _textAnimation.value,
                  child: const Center(
                    child: Text(
                      '"Procrastination ends HERE, champ" 💪',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: MangaTheme.shadowGray,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
