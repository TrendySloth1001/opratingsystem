import 'package:flutter/material.dart';
import '../data/os_content.dart';
import '../models/study_content.dart';
import '../services/storage_service.dart';
import '../theme/manga_theme.dart';
import '../widgets/manga_widgets.dart';
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
            expandedHeight: 200,
            pinned: true,
            backgroundColor: MangaTheme.inkBlack,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(color: MangaTheme.inkBlack),
                  CustomPaint(
                    painter: _MangaSpeedlinesPainter(),
                    child: Container(),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          'OS MASTERY',
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                color: MangaTheme.paperWhite,
                                shadows: [
                                  Shadow(
                                    color: MangaTheme.mangaRed.withOpacity(0.8),
                                    offset: const Offset(4, 4),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                        ),
                        Text(
                          'STUDY TRACKER',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: MangaTheme.highlightYellow,
                                letterSpacing: 4,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Where procrastination goes to die',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: MangaTheme.paperWhite.withOpacity(0.7),
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],
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
                    // Stats Panel
                    MangaPanel(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.auto_stories,
                                  color: MangaTheme.mangaRed,
                                  size: 32,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _getMotivationalRoast(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(color: MangaTheme.mangaRed),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _getProgressMessage(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 20),
                            MangaProgressBar(
                              progress: _getOverallProgress(),
                              label: _getOverallProgress() == 0
                                  ? 'Wow, starting from absolute zero'
                                  : _getOverallProgress() < 0.3
                                  ? 'Barely scratching the surface'
                                  : _getOverallProgress() < 0.7
                                  ? 'Getting somewhere... finally'
                                  : _getOverallProgress() < 1.0
                                  ? 'Almost there, champ'
                                  : 'LEGEND STATUS ACHIEVED',
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'THE DAMAGE REPORT',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
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
                    ...osModules.map((module) => _buildModuleCard(module)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

  String _getModuleRoast(int completed, int total) {
    if (completed == 0) {
      return "Untouched. Like your gym membership.";
    } else if (completed == total) {
      return "CONQUERED! You're basically a professor now.";
    } else if (completed == 1) {
      return "One down. Rome wasn't built in a day... but you're testing that theory.";
    } else if (completed < total / 2) {
      return "Started strong... then what happened?";
    } else {
      return "Almost there! Don't choke now!";
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

  Widget _buildModuleCard(Module module) {
    final completedTopics = module.topics
        .where((t) => _progressMap[t.id]?.isCompleted ?? false)
        .length;
    final totalTopics = module.topics.length;
    final progress = totalTopics > 0 ? completedTopics / totalTopics : 0.0;
    final isComplete = progress == 1.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
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
        child: Container(
          decoration: BoxDecoration(
            color: isComplete
                ? MangaTheme.highlightYellow.withOpacity(0.1)
                : MangaTheme.paperWhite,
            border: Border.all(
              color: MangaTheme.inkBlack,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: MangaTheme.inkBlack,
                offset: const Offset(8, 8),
                blurRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Module number badge
                    Stack(
                      children: [
                        // Shadow layer
                        Positioned(
                          left: 5,
                          top: 5,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              color: MangaTheme.inkBlack,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        // Main circle
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: isComplete
                                ? MangaTheme.highlightYellow
                                : MangaTheme.mangaRed,
                            border: Border.all(
                              color: MangaTheme.inkBlack,
                              width: 4,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (isComplete
                                        ? MangaTheme.highlightYellow
                                        : MangaTheme.mangaRed)
                                    .withOpacity(0.4),
                                blurRadius: 16,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${module.id}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    color: MangaTheme.inkBlack,
                                    fontWeight: FontWeight.w900,
                                    shadows: [
                                      Shadow(
                                        color: MangaTheme.paperWhite
                                            .withOpacity(0.5),
                                        offset: const Offset(2, 2),
                                        blurRadius: 0,
                                      ),
                                    ],
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            module.title,
                            style:
                                Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      height: 1.2,
                                    ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _getModuleRoast(completedTopics, totalTopics),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: MangaTheme.shadowGray,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              MangaBadge(
                                text: '$completedTopics/$totalTopics Topics',
                                color: isComplete
                                    ? MangaTheme.highlightYellow
                                    : MangaTheme.speedlineBlue,
                              ),
                              if (isComplete) ...[
                                const SizedBox(width: 8),
                                const MangaBadge(
                                  text: 'COMPLETE!',
                                  color: MangaTheme.highlightYellow,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Enhanced progress bar
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: MangaTheme.panelGray,
                    border: Border.all(color: MangaTheme.inkBlack, width: 3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isComplete
                            ? MangaTheme.highlightYellow
                            : MangaTheme.mangaRed,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
