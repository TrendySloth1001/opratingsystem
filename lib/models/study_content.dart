class Module {
  final int id;
  final String title;
  final List<Topic> topics;

  Module({required this.id, required this.title, required this.topics});
}

class Topic {
  final String id;
  final String title;
  final String content;
  final List<PYQ> pyqs;

  Topic({
    required this.id,
    required this.title,
    required this.content,
    required this.pyqs,
  });
}

class PYQ {
  final String question;
  final String type; // 'theory' or 'numerical'
  final String? answer;
  final bool? hasDiagram;

  PYQ({
    required this.question,
    required this.type,
    this.answer,
    this.hasDiagram = false,
  });
}

class StudyProgress {
  final String topicId;
  final bool isCompleted;
  final DateTime? completedDate;
  final int timeSpent; // in minutes

  StudyProgress({
    required this.topicId,
    required this.isCompleted,
    this.completedDate,
    this.timeSpent = 0,
  });

  Map<String, dynamic> toJson() => {
    'topicId': topicId,
    'isCompleted': isCompleted,
    'completedDate': completedDate?.toIso8601String(),
    'timeSpent': timeSpent,
  };

  factory StudyProgress.fromJson(Map<String, dynamic> json) => StudyProgress(
    topicId: json['topicId'],
    isCompleted: json['isCompleted'],
    completedDate: json['completedDate'] != null
        ? DateTime.parse(json['completedDate'])
        : null,
    timeSpent: json['timeSpent'] ?? 0,
  );
}
