import 'dart:async';
import 'package:flutter/material.dart';
import '../models/study_content.dart';
import '../services/storage_service.dart';
import '../theme/manga_theme.dart';
import '../widgets/manga_widgets.dart';
import '../widgets/expandable_question.dart';
import '../widgets/diagrams/process_diagrams.dart';
import '../widgets/diagrams/scheduling_diagrams.dart';

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

  Widget? _getDiagramForQuestion(PYQ pyq) {
    if (pyq.hasDiagram != true) return null;

    // Module 2.1 diagrams
    if (pyq.question.contains('Process State Transition')) {
      return const ProcessStateDiagram();
    }
    if (pyq.question.contains('Five-state')) {
      return const ProcessStateDiagram();
    }
    if (pyq.question.contains('PCB')) {
      return const PCBDiagram();
    }
    if (pyq.question.contains('Process and a Thread')) {
      return const ProcessVsProgramDiagram();
    }
    if (pyq.question.contains('Context Switch')) {
      return const ContextSwitchDiagram();
    }

    // Module 2.2 diagrams
    if (pyq.question.contains('Preemptive and Non-preemptive')) {
      return const PreemptiveComparisonDiagram();
    }
    if (pyq.question.contains('Round Robin Algorithm')) {
      return const RoundRobinDiagram();
    }
    if (pyq.question.contains('Gantt chart')) {
      return GanttChartDiagram(
        title: 'Example Gantt Chart',
        processes: [
          GanttProcess(
            name: 'P1',
            startTime: 0,
            endTime: 4,
            color: MangaTheme.mangaRed.withOpacity(0.6),
          ),
          GanttProcess(
            name: 'P2',
            startTime: 4,
            endTime: 7,
            color: MangaTheme.speedlineBlue.withOpacity(0.6),
          ),
          GanttProcess(
            name: 'P3',
            startTime: 7,
            endTime: 8,
            color: MangaTheme.accentOrange.withOpacity(0.6),
          ),
        ],
      );
    }

    return null;
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
        final messages = [
          'BOOM! Another one bites the dust!',
          'CRUSHED IT! Next victim?',
          'DEMOLISHED! Keep the momentum!',
          'DESTROYED! You\'re on fire!',
          'CONQUERED! Unstoppable force!',
          'ANNIHILATED! Who\'s next?',
        ];
        final randomMsg = messages[minutes % messages.length];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              randomMsg,
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
    } else {
      _checkController.reverse();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unmarked. Need a refresher?',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: MangaTheme.inkBlack),
            ),
            backgroundColor: MangaTheme.panelGray,
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
                        (pyq) => ExpandableQuestion(
                          question: pyq,
                          diagram: _getDiagramForQuestion(pyq),
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
