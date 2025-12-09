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
              background: Container(
                decoration: BoxDecoration(
                  color: MangaTheme.inkBlack,
                  image: DecorationImage(
                    image: const AssetImage('assets/speedlines.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      MangaTheme.inkBlack.withOpacity(0.7),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Center(
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
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: MangaTheme.mangaRed,
                      border: Border.all(color: MangaTheme.inkBlack, width: 3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${module.id}',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(color: MangaTheme.paperWhite),
                      ),
                    ),
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
