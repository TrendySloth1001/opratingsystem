import 'package:flutter/material.dart';
import '../data/os_content.dart';
import '../models/study_content.dart';
import '../services/storage_service.dart';
import '../theme/manga_theme.dart';
import '../widgets/manga_widgets.dart';
import '../widgets/manga_module_card.dart';
import 'module_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final StorageService _storage = StorageService();
  Map<String, StudyProgress> _progressMap = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _loadProgress();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    final progressList = await _storage.loadProgress();
    setState(() {
      _progressMap = {for (var p in progressList) p.topicId: p};
      _isLoading = false;
    });
    _animationController.forward();
  }

  int _getCompletedCount() {
    return _progressMap.values.where((p) => p.isCompleted).length;
  }

  int _getTotalTopics() {
    return osModules.fold(0, (sum, module) => sum + module.topics.length);
  }

  double _getOverallProgress() {
    final total = _getTotalTopics();
    if (total == 0) return 0.0;
    return _getCompletedCount() / total;
  }

  int _getTotalStudyTime() {
    return _progressMap.values.fold(0, (sum, p) => sum + p.timeSpent);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: MangaTheme.paperWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: MangaTheme.mangaRed,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // 🔥 Gradient background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [MangaTheme.mangaRed, MangaTheme.accentOrange],
                      ),
                    ),
                  ),
                  // ⚡ Action burst
                  CustomPaint(
                    painter: _MangaSpeedlinesPainter(),
                    child: Container(),
                  ),
                  // 📝 Content
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // 🎯 Badge icon
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: MangaTheme.paperWhite,
                                  shape: BoxShape.circle,
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
                                child: const Text(
                                  '💪',
                                  style: TextStyle(fontSize: 28),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'TIME TO GRIND',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        color: MangaTheme.paperWhite,
                                        height: 1,
                                        shadows: [
                                          Shadow(
                                            color: MangaTheme.inkBlack,
                                            offset: Offset(3, 3),
                                            blurRadius: 0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _getFunnyGreeting(),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: MangaTheme.paperWhite,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // 📊 Quick stats
                          Row(
                            children: [
                              _buildQuickStat(
                                '${_getCompletedCount()}/${_getTotalTopics()}',
                                'Topics Done',
                              ),
                              const SizedBox(width: 16),
                              _buildQuickStat(
                                '${(_getOverallProgress() * 100).toInt()}%',
                                'Completion',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 💬 Motivational Roast Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: MangaTheme.highlightYellow.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('💬', style: TextStyle(fontSize: 32)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _getMotivationalRoast(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: MangaTheme.inkBlack,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _getProgressMessage(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: MangaTheme.shadowGray,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 📊 Big Progress Bar
                    MangaPanel(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'OVERALL PROGRESS',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                Text(
                                  '${(_getOverallProgress() * 100).toInt()}%',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: MangaTheme.mangaRed,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            MangaProgressBar(
                              progress: _getOverallProgress(),
                              label: _getProgressRoast(),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              '📈 YOUR STATS (NO LYING)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  context,
                                  '${_getCompletedCount()}/${_getTotalTopics()}',
                                  _getCompletedCount() == 0
                                      ? 'Slacker'
                                      : _getCompletedCount() ==
                                            _getTotalTopics()
                                      ? 'BEAST'
                                      : 'Topics',
                                  Icons.book,
                                ),
                                Container(
                                  width: 3,
                                  height: 50,
                                  color: MangaTheme.primaryBlack,
                                ),
                                _buildStatItem(
                                  context,
                                  '${_getTotalStudyTime()}',
                                  _getTotalStudyTime() == 0
                                      ? 'Tourist'
                                      : _getTotalStudyTime() > 120
                                      ? 'Grinder'
                                      : 'Minutes',
                                  Icons.timer,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Modules Section
                    Text(
                      'CHOOSE YOUR CHAPTER',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 16),
                    ...osModules.map((module) {
                      final completedTopics = module.topics
                          .where(
                            (t) => _progressMap[t.id]?.isCompleted ?? false,
                          )
                          .length;
                      final totalTopics = module.topics.length;
                      final progress = totalTopics > 0
                          ? completedTopics / totalTopics
                          : 0.0;

                      return UltraMangaCard(
                        module: module,
                        progress: progress,
                        completedTopics: completedTopics,
                        totalTopics: totalTopics,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModuleScreen(
                                module: module,
                                progressMap: _progressMap,
                                onProgressUpdate: _loadProgress,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFunnyGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return "Up this late? Dedication or bad decisions?";
    if (hour < 12) return "Morning grind szn \ud83d\udd25";
    if (hour < 17) return "Afternoon study session activated!";
    if (hour < 21) return "Evening warrior reporting for duty!";
    return "Night owl mode engaged \ud83e\udd89";
  }

  Widget _buildQuickStat(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: MangaTheme.paperWhite.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: MangaTheme.paperWhite, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: MangaTheme.paperWhite,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: MangaTheme.paperWhite.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  String _getProgressRoast() {
    final progress = _getOverallProgress();
    if (progress == 0) return "Not even started. Impressive avoidance skills.";
    if (progress < 0.3) return "Baby steps... teeny tiny baby steps.";
    if (progress < 0.6) return "Half-committed. Classic move.";
    if (progress < 0.9) return "Getting serious! Keep that energy!";
    if (progress < 1.0) return "ALMOST DONE! Finish strong!";
    return "100% COMPLETE! Absolute legend!";
  }

  String _getMotivationalRoast() {
    final progress = _getOverallProgress();

    if (progress == 0) {
      return "ZERO PROGRESS? Bold strategy.";
    } else if (progress < 0.2) {
      return "Oh look, you opened the app!";
    } else if (progress < 0.4) {
      return "Slow and steady... very slow.";
    } else if (progress < 0.6) {
      return "Finally! Some actual effort!";
    } else if (progress < 0.8) {
      return "Okay, now we're cooking!";
    } else if (progress < 1.0) {
      return "SO CLOSE! Don't give up now!";
    } else {
      return "ABSOLUTE LEGEND! Go ace that exam!";
    }
  }

  String _getProgressMessage() {
    final completed = _getCompletedCount();
    final total = _getTotalTopics();
    final time = _getTotalStudyTime();

    if (completed == 0) {
      return "The journey of a thousand miles begins with opening the book. You haven't even done that yet.";
    } else if (completed < 3) {
      return "Nice start! Only ${total - completed} more to go. Piece of cake, right?";
    } else if (completed < total / 2) {
      return "Halfway? Not even close. But hey, $completed down! Keep the momentum!";
    } else if (completed < total) {
      return "You're actually doing this! $time minutes invested. That's like... ${(time / 60).floor()} episodes of anime you sacrificed!";
    } else {
      return "ALL TOPICS CONQUERED! You absolute madlad! Time to destroy that exam!";
    }
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32, color: MangaTheme.mangaRed),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(color: MangaTheme.mangaRed),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Custom painter for manga-style speedlines
class _MangaSpeedlinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MangaTheme.paperWhite.withOpacity(0.08)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final boldPaint = Paint()
      ..color = MangaTheme.mangaRed.withOpacity(0.15)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Diagonal speedlines from top corners
    for (int i = 0; i < 20; i++) {
      final offsetY = i * (size.height / 20);

      // Left side speedlines
      canvas.drawLine(
        Offset(0, offsetY),
        Offset(size.width * 0.4, size.height * 0.7 + offsetY * 0.3),
        i % 3 == 0 ? boldPaint : paint,
      );

      // Right side speedlines
      canvas.drawLine(
        Offset(size.width, offsetY),
        Offset(size.width * 0.6, size.height * 0.7 + offsetY * 0.3),
        i % 3 == 0 ? boldPaint : paint,
      );
    }

    // Action lines
    final actionPaint = Paint()
      ..color = MangaTheme.highlightYellow.withOpacity(0.1)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(size.width * 0.2 + i * 20, 0),
        Offset(size.width * 0.8 + i * 20, size.height),
        actionPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
