import 'dart:async';
import 'package:flutter/material.dart';
import '../models/study_content.dart';
import '../services/storage_service.dart';
import '../theme/manga_theme.dart';
import '../widgets/manga_widgets.dart';

class TopicDetailScreen extends StatefulWidget {
  final Topic topic;
  final StudyProgress? progress;

  const TopicDetailScreen({super.key, required this.topic, this.progress});

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen>
    with SingleTickerProviderStateMixin {
  final StorageService _storage = StorageService();
  bool _isCompleted = false;
  Timer? _timer;
  int _elapsedSeconds = 0;
  late AnimationController _checkController;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.progress?.isCompleted ?? false;
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _checkController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  Future<void> _toggleCompletion() async {
    final minutes = (_elapsedSeconds / 60).ceil();
    await _storage.updateTopicProgress(
      topicId: widget.topic.id,
      isCompleted: !_isCompleted,
      additionalTime: minutes,
    );

    setState(() {
      _isCompleted = !_isCompleted;
    });

    if (_isCompleted) {
      _checkController.forward();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'NICE! Topic Completed!',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            backgroundColor: MangaTheme.highlightYellow,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: MangaTheme.inkBlack, width: 3),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_elapsedSeconds / 60).floor();
    final seconds = _elapsedSeconds % 60;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.id),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: MangaTheme.mangaRed,
                  border: Border.all(color: MangaTheme.paperWhite, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer,
                      color: MangaTheme.paperWhite,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: MangaTheme.paperWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Topic Title
                      MangaPanel(
                        isCompleted: _isCompleted,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.topic.title,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineLarge,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  MangaBadge(
                                    text: '${widget.topic.pyqs.length} PYQs',
                                    color: MangaTheme.accentOrange,
                                  ),
                                  const SizedBox(width: 8),
                                  if (_isCompleted)
                                    const MangaBadge(
                                      text: 'COMPLETED',
                                      color: MangaTheme.highlightYellow,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Content Section
                      Text(
                        'CONTENT',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 12),
                      MangaPanel(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            widget.topic.content,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // PYQs Section
                      Text(
                        'PREVIOUS YEAR QUESTIONS',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 12),
                      ...widget.topic.pyqs.map(
                        (pyq) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: MangaPanel(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      MangaBadge(
                                        text: pyq.type.toUpperCase(),
                                        color: pyq.type == 'theory'
                                            ? MangaTheme.speedlineBlue
                                            : MangaTheme.accentOrange,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    pyq.question,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Floating Action Button
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: _toggleCompletion,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: _isCompleted
                      ? MangaTheme.highlightYellow
                      : MangaTheme.mangaRed,
                  border: Border.all(color: MangaTheme.inkBlack, width: 3),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: MangaTheme.inkBlack.withOpacity(0.5),
                      offset: const Offset(4, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: _isCompleted
                    ? ScaleTransition(
                        scale: _checkAnimation,
                        child: const Icon(
                          Icons.check,
                          color: MangaTheme.inkBlack,
                          size: 40,
                        ),
                      )
                    : const Icon(
                        Icons.done_all,
                        color: MangaTheme.paperWhite,
                        size: 40,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
