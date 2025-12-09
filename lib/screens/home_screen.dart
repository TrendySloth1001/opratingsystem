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
                                Text(
                                  'YOUR PROGRESS',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displaySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            MangaProgressBar(
                              progress: _getOverallProgress(),
                              label: 'Overall Completion',
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  context,
                                  '${_getCompletedCount()}/${_getTotalTopics()}',
                                  'Topics',
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
                                  'Minutes',
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: MangaPanel(
        isCompleted: progress == 1.0,
        hasAction: true,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      // Shadow
                      Positioned(
                        left: 4,
                        top: 4,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: MangaTheme.inkBlack,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // Main circle
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: MangaTheme.mangaRed,
                          border: Border.all(
                            color: MangaTheme.inkBlack,
                            width: 4,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: MangaTheme.mangaRed.withOpacity(0.5),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${module.id}',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  color: MangaTheme.paperWhite,
                                  shadows: [
                                    const Shadow(
                                      color: MangaTheme.inkBlack,
                                      offset: Offset(2, 2),
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            MangaBadge(
                              text: '$completedTopics/$totalTopics Topics',
                              color: progress == 1.0
                                  ? MangaTheme.highlightYellow
                                  : MangaTheme.speedlineBlue,
                            ),
                            if (progress == 1.0) ...[
                              const SizedBox(width: 8),
                              const MangaBadge(
                                text: 'COMPLETE',
                                color: MangaTheme.highlightYellow,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: MangaTheme.primaryBlack,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: MangaTheme.panelGray,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress == 1.0
                        ? MangaTheme.highlightYellow
                        : MangaTheme.mangaRed,
                  ),
                ),
              ),
            ],
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
