import 'package:flutter/material.dart';
import '../theme/manga_theme.dart';
import '../models/study_content.dart';

class ExpandableQuestion extends StatefulWidget {
  final PYQ question;
  final Widget? diagram;

  const ExpandableQuestion({super.key, required this.question, this.diagram});

  @override
  State<ExpandableQuestion> createState() => _ExpandableQuestionState();
}

class _ExpandableQuestionState extends State<ExpandableQuestion>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: MangaTheme.mangaPanelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header
          InkWell(
            onTap: _toggleExpanded,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isExpanded
                    ? MangaTheme.mangaRed.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  // Expand icon
                  RotationTransition(
                    turns: _rotationAnimation,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: MangaTheme.mangaRed,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Question text
                  Expanded(
                    child: Text(
                      widget.question.question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MangaTheme.inkBlack,
                      ),
                    ),
                  ),
                  // Type badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: MangaTheme.highlightYellow,
                      border: Border.all(color: MangaTheme.inkBlack, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.question.type,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: MangaTheme.inkBlack,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Answer (expandable)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: MangaTheme.paperWhite,
                border: Border(
                  top: BorderSide(color: MangaTheme.inkBlack, width: 2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.question.answer != null) ...[
                    Text(
                      widget.question.answer!,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: MangaTheme.inkBlack,
                      ),
                    ),
                    if (widget.diagram != null) const SizedBox(height: 20),
                  ],
                  if (widget.diagram != null) widget.diagram!,
                ],
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
