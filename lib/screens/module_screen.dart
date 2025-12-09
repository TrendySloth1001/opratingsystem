import 'package:flutter/material.dart';
import '../models/study_content.dart';
import '../theme/manga_theme.dart';
import '../widgets/manga_widgets.dart';
import 'topic_detail_screen.dart';

class ModuleScreen extends StatelessWidget {
  final Module module;
  final Map<String, StudyProgress> progressMap;
  final VoidCallback onProgressUpdate;

  const ModuleScreen({
    super.key,
    required this.module,
    required this.progressMap,
    required this.onProgressUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MODULE ${module.id}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: MangaBadge(
                text: '${_getCompletedCount()}/${module.topics.length}',
                color: MangaTheme.highlightYellow,
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: MangaTheme.mangaPanelDecoration(hasAction: true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: MangaTheme.mangaRed,
                          border: Border.all(
                            color: MangaTheme.inkBlack,
                            width: 3,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${module.id}',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  color: MangaTheme.paperWhite,
                                  fontSize: 24,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          module.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  MangaProgressBar(
                    progress: _getProgress(),
                    label: 'Chapter Progress',
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final topic = module.topics[index];
                final progress = progressMap[topic.id];
                final isCompleted = progress?.isCompleted ?? false;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: MangaPanel(
                    isCompleted: isCompleted,
                    hasAction: !isCompleted,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopicDetailScreen(
                            topic: topic,
                            progress: progress,
                          ),
                        ),
                      );
                      onProgressUpdate();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? MangaTheme.highlightYellow
                                  : MangaTheme.speedlineBlue,
                              border: Border.all(
                                color: MangaTheme.inkBlack,
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isCompleted ? Icons.check : Icons.book,
                              color: MangaTheme.paperWhite,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  topic.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    MangaBadge(
                                      text: '${topic.pyqs.length} PYQs',
                                      color: MangaTheme.accentOrange,
                                    ),
                                    if (progress != null &&
                                        progress.timeSpent > 0) ...[
                                      const SizedBox(width: 8),
                                      MangaBadge(
                                        text: '${progress.timeSpent} min',
                                        color: MangaTheme.shadowGray,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }, childCount: module.topics.length),
            ),
          ),
        ],
      ),
    );
  }

  int _getCompletedCount() {
    return module.topics
        .where((t) => progressMap[t.id]?.isCompleted ?? false)
        .length;
  }

  double _getProgress() {
    if (module.topics.isEmpty) return 0.0;
    return _getCompletedCount() / module.topics.length;
  }
}
