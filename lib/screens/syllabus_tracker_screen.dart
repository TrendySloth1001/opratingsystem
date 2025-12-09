import 'package:flutter/material.dart';
import '../theme/manga_theme.dart';
import '../services/storage_service.dart';

/// 📚 SYLLABUS TRACKER - Track progress minute by minute!
class SyllabusTrackerScreen extends StatefulWidget {
  const SyllabusTrackerScreen({super.key});

  @override
  State<SyllabusTrackerScreen> createState() => _SyllabusTrackerScreenState();
}

class _SyllabusTrackerScreenState extends State<SyllabusTrackerScreen> {
  final StorageService _storage = StorageService();
  Map<String, bool> _completedConcepts = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await _storage.getCompletedConcepts();
    setState(() {
      _completedConcepts = progress;
    });
  }

  Future<void> _toggleConcept(String conceptId) async {
    setState(() {
      _completedConcepts[conceptId] = !(_completedConcepts[conceptId] ?? false);
    });
    await _storage.saveCompletedConcept(
      conceptId,
      _completedConcepts[conceptId]!,
    );
  }

  List<SubTopic> _parseSubTopics(ConceptItem concept) {
    // Split by comma and colon to extract individual topics
    String content = concept.title;

    // First, check if there's a colon (like "Threads: Definition, Types")
    if (content.contains(':')) {
      final parts = content.split(':');
      final prefix = parts[0].trim();
      final topics = parts[1].split(',').map((t) => t.trim()).toList();

      return List.generate(topics.length, (index) {
        return SubTopic(concept.id, index, '$prefix: ${topics[index]}');
      });
    }

    // Otherwise, just split by comma
    final topics = content.split(',').map((t) => t.trim()).toList();

    return List.generate(topics.length, (index) {
      return SubTopic(concept.id, index, topics[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MangaTheme.paperWhite,
      appBar: AppBar(
        backgroundColor: MangaTheme.mangaRed,
        elevation: 0,
        toolbarHeight: 80,
        title: Stack(
          children: [
            // Comic-style title with outline effect
            Text(
              'MODULE TRACKER',
              style: TextStyle(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 6
                  ..color = MangaTheme.inkBlack,
                fontWeight: FontWeight.w900,
                fontSize: 28,
                letterSpacing: 2.0,
              ),
            ),
            const Text(
              'MODULE TRACKER',
              style: TextStyle(
                color: MangaTheme.paperWhite,
                fontWeight: FontWeight.w900,
                fontSize: 28,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(color: MangaTheme.inkBlack, width: 5),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildModuleSection(
            moduleNumber: '1',
            title: 'Operating System Overview',
            hours: '4',
            icon: Icons.computer_rounded,
            iconColor: Colors.blue,
            concepts: [
              ConceptItem(
                '1.1',
                'Introduction, Objectives, Functions and Evolution of OS',
              ),
              ConceptItem(
                '1.2',
                'OS Structures: Layered, Monolithic and Microkernel',
              ),
              ConceptItem('1.3', 'Linux Kernel, Shell and System Calls'),
            ],
          ),
          const SizedBox(height: 20),
          _buildModuleSection(
            moduleNumber: '2',
            title: 'Process and Process Scheduling',
            hours: '9',
            icon: Icons.settings_suggest_rounded,
            iconColor: Colors.orange,
            concepts: [
              ConceptItem('2.1', 'Process Concept, States, Description, PCB'),
              ConceptItem(
                '2.2',
                'Uniprocessor Scheduling (FCFS, SJF, SRTN, Priority, RR)',
              ),
              ConceptItem('2.3', 'Threads: Definition, Types, Multithreading'),
            ],
          ),
          const SizedBox(height: 20),
          _buildModuleSection(
            moduleNumber: '3',
            title: 'Process Synchronization and Deadlocks',
            hours: '9',
            icon: Icons.sync_rounded,
            iconColor: Colors.purple,
            concepts: [
              ConceptItem('3.1', 'Concurrency, IPC, Process Synchronization'),
              ConceptItem(
                '3.2',
                'Mutual Exclusion, Semaphores, Producer-Consumer',
              ),
              ConceptItem(
                '3.3',
                'Deadlock: Prevention, Avoidance, Detection, Recovery',
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildModuleSection(
            moduleNumber: '4',
            title: 'Memory Management',
            hours: '9',
            icon: Icons.memory_rounded,
            iconColor: Colors.red,
            concepts: [
              ConceptItem(
                '4.1',
                'Memory Partitioning, Allocation, Paging, Segmentation, TLB',
              ),
              ConceptItem(
                '4.2',
                'Virtual Memory, Page Replacement (FIFO, Optimal, LRU), Thrashing',
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildModuleSection(
            moduleNumber: '5',
            title: 'File Management',
            hours: '4',
            icon: Icons.folder_rounded,
            iconColor: Colors.green,
            concepts: [
              ConceptItem(
                '5.1',
                'File Organization, Access, Directories, Sharing',
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildModuleSection(
            moduleNumber: '6',
            title: 'I/O Management',
            hours: '4',
            icon: Icons.storage_rounded,
            iconColor: Colors.teal,
            concepts: [
              ConceptItem(
                '6.1',
                'I/O Devices, Disk Organization, Scheduling (FCFS, SSTF, SCAN, C-SCAN, LOOK, C-LOOK)',
              ),
            ],
          ),
          const SizedBox(height: 40),
          _buildProgressSummary(),
        ],
      ),
    );
  }

  Widget _buildModuleSection({
    required String moduleNumber,
    required String title,
    required String hours,
    required IconData icon,
    required Color iconColor,
    required List<ConceptItem> concepts,
  }) {
    // Parse all sub-topics from concepts
    List<SubTopic> allSubTopics = [];
    for (var concept in concepts) {
      allSubTopics.addAll(_parseSubTopics(concept));
    }

    final completedCount = allSubTopics
        .where(
          (st) => _completedConcepts['${st.conceptId}_${st.index}'] ?? false,
        )
        .length;
    final totalCount = allSubTopics.length;
    final percentage = totalCount > 0
        ? (completedCount / totalCount * 100).toInt()
        : 0;

    return Container(
      decoration: BoxDecoration(
        color: MangaTheme.paperWhite,
        border: Border.all(color: MangaTheme.inkBlack, width: 4),
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
          // Module Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: percentage == 100
                  ? MangaTheme.highlightYellow
                  : iconColor.withOpacity(0.1),
              border: const Border(
                bottom: BorderSide(color: MangaTheme.inkBlack, width: 3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icon badge
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconColor,
                        border: Border.all(
                          color: MangaTheme.inkBlack,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: MangaTheme.inkBlack,
                            offset: Offset(3, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Icon(icon, color: MangaTheme.paperWhite, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: MangaTheme.mangaRed,
                        border: Border.all(
                          color: MangaTheme.inkBlack,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        'MODULE $moduleNumber',
                        style: const TextStyle(
                          color: MangaTheme.paperWhite,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: MangaTheme.inkBlack,
                        border: Border.all(
                          color: MangaTheme.inkBlack,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '$hours HRS',
                        style: const TextStyle(
                          color: MangaTheme.highlightYellow,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (percentage == 100)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(
                            color: MangaTheme.inkBlack,
                            width: 3,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: MangaTheme.paperWhite,
                          size: 24,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: MangaTheme.inkBlack,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$completedCount/$totalCount CONCEPTS',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          '$percentage%',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: percentage == 100
                                ? MangaTheme.mangaRed
                                : MangaTheme.inkBlack,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                          color: MangaTheme.inkBlack,
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: percentage / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                color: percentage == 100
                                    ? Colors.green
                                    : MangaTheme.mangaRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Concepts List with Sub-topics
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: concepts.map((concept) {
                return _buildConceptWithSubTopics(concept, iconColor);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConceptWithSubTopics(ConceptItem concept, Color accentColor) {
    final subTopics = _parseSubTopics(concept);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: MangaTheme.paperWhite,
        border: Border.all(color: MangaTheme.inkBlack, width: 3),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: MangaTheme.inkBlack,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Concept header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.2),
              border: const Border(
                bottom: BorderSide(color: MangaTheme.inkBlack, width: 2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor,
                    border: Border.all(color: MangaTheme.inkBlack, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    concept.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      color: MangaTheme.paperWhite,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${subTopics.length} Topics',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: MangaTheme.inkBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Sub-topics list
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: subTopics.map((subTopic) {
                final subTopicId = '${subTopic.conceptId}_${subTopic.index}';
                final isCompleted = _completedConcepts[subTopicId] ?? false;
                return _buildSubTopicCheckbox(
                  subTopic,
                  subTopicId,
                  isCompleted,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTopicCheckbox(
    SubTopic subTopic,
    String subTopicId,
    bool isCompleted,
  ) {
    return GestureDetector(
      onTap: () => _toggleConcept(subTopicId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isCompleted
              ? MangaTheme.highlightYellow.withOpacity(0.3)
              : MangaTheme.paperWhite,
          border: Border.all(
            color: isCompleted ? MangaTheme.mangaRed : Colors.grey[400]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? MangaTheme.mangaRed
                    : MangaTheme.paperWhite,
                border: Border.all(color: MangaTheme.inkBlack, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.check_rounded,
                      color: MangaTheme.paperWhite,
                      size: 16,
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                subTopic.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isCompleted
                      ? MangaTheme.inkBlack.withOpacity(0.7)
                      : MangaTheme.inkBlack,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSummary() {
    // Calculate total sub-topics across all modules
    int totalSubTopics = 0;
    final allConcepts = [
      ConceptItem(
        '1.1',
        'Introduction, Objectives, Functions and Evolution of OS',
      ),
      ConceptItem('1.2', 'OS Structures: Layered, Monolithic and Microkernel'),
      ConceptItem('1.3', 'Linux Kernel, Shell and System Calls'),
      ConceptItem('2.1', 'Process Concept, States, Description, PCB'),
      ConceptItem(
        '2.2',
        'Uniprocessor Scheduling (FCFS, SJF, SRTN, Priority, RR)',
      ),
      ConceptItem('2.3', 'Threads: Definition, Types, Multithreading'),
      ConceptItem('3.1', 'Concurrency, IPC, Process Synchronization'),
      ConceptItem('3.2', 'Mutual Exclusion, Semaphores, Producer-Consumer'),
      ConceptItem(
        '3.3',
        'Deadlock: Prevention, Avoidance, Detection, Recovery',
      ),
      ConceptItem(
        '4.1',
        'Memory Partitioning, Allocation, Paging, Segmentation, TLB',
      ),
      ConceptItem(
        '4.2',
        'Virtual Memory, Page Replacement (FIFO, Optimal, LRU), Thrashing',
      ),
      ConceptItem('5.1', 'File Organization, Access, Directories, Sharing'),
      ConceptItem(
        '6.1',
        'I/O Devices, Disk Organization, Scheduling (FCFS, SSTF, SCAN, C-SCAN, LOOK, C-LOOK)',
      ),
    ];

    for (var concept in allConcepts) {
      totalSubTopics += _parseSubTopics(concept).length;
    }

    final completedConcepts = _completedConcepts.values.where((v) => v).length;
    final percentage = totalSubTopics > 0
        ? (completedConcepts / totalSubTopics * 100).toInt()
        : 0;

    // Generate roast based on completion percentage
    String getRoastMessage() {
      if (percentage == 100) return "WAIT... YOU ACTUALLY FINISHED? 🤯";
      if (percentage >= 90) return "Almost there! Don't choke now 😤";
      if (percentage >= 75)
        return "Not bad, but exams won't wait for u bestie 📚";
      if (percentage >= 50) return "Mid progress = Mid grades, step it up! ⚡";
      if (percentage >= 25) return "Bro really said \"I'll start tomorrow\" 💀";
      return "Touch grass? Nah, TOUCH YOUR BOOKS FR FR 📖";
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: percentage == 100
            ? const LinearGradient(
                colors: [MangaTheme.highlightYellow, Color(0xFFFFE082)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [MangaTheme.paperWhite, Colors.grey.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        border: Border.all(color: MangaTheme.inkBlack, width: 4),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: MangaTheme.inkBlack,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Roast banner at the top
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: percentage == 100 ? Colors.green : MangaTheme.mangaRed,
              border: Border.all(color: MangaTheme.inkBlack, width: 3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  percentage == 100
                      ? Icons.celebration_rounded
                      : (percentage >= 75
                            ? Icons.directions_run_rounded
                            : Icons.warning_amber_rounded),
                  color: MangaTheme.paperWhite,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    getRoastMessage(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: MangaTheme.paperWhite,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: percentage == 100 ? Colors.green : MangaTheme.mangaRed,
                  border: Border.all(color: MangaTheme.inkBlack, width: 3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  percentage == 100
                      ? Icons.emoji_events_rounded
                      : Icons.track_changes_rounded,
                  color: MangaTheme.highlightYellow,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'OVERALL PROGRESS',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '$completedConcepts / $totalSubTopics',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 48,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'CONCEPTS COMPLETED',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: 1.2,
              color: MangaTheme.inkBlack.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: MangaTheme.inkBlack, width: 3),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: percentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: percentage == 100
                          ? Colors.green
                          : MangaTheme.mangaRed,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '$percentage%',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: MangaTheme.inkBlack,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (percentage == 100) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: MangaTheme.inkBlack, width: 3),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: MangaTheme.inkBlack,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.celebration_rounded,
                    color: MangaTheme.paperWhite,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'SYLLABUS COMPLETE!',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: MangaTheme.paperWhite,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.celebration_rounded,
                    color: MangaTheme.paperWhite,
                    size: 24,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ConceptItem {
  final String id;
  final String title;

  ConceptItem(this.id, this.title);
}

class SubTopic {
  final String conceptId;
  final int index;
  final String title;

  SubTopic(this.conceptId, this.index, this.title);
}
