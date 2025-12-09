import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/study_content.dart';

class StorageService {
  static const String _progressKey = 'study_progress';

  Future<void> saveProgress(List<StudyProgress> progressList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = progressList.map((p) => p.toJson()).toList();
    await prefs.setString(_progressKey, jsonEncode(jsonList));
  }

  Future<List<StudyProgress>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_progressKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => StudyProgress.fromJson(json)).toList();
  }

  Future<void> updateTopicProgress({
    required String topicId,
    required bool isCompleted,
    int? additionalTime,
  }) async {
    final progressList = await loadProgress();
    final index = progressList.indexWhere((p) => p.topicId == topicId);

    if (index != -1) {
      final existing = progressList[index];
      progressList[index] = StudyProgress(
        topicId: topicId,
        isCompleted: isCompleted,
        completedDate: isCompleted ? DateTime.now() : existing.completedDate,
        timeSpent: existing.timeSpent + (additionalTime ?? 0),
      );
    } else {
      progressList.add(
        StudyProgress(
          topicId: topicId,
          isCompleted: isCompleted,
          completedDate: isCompleted ? DateTime.now() : null,
          timeSpent: additionalTime ?? 0,
        ),
      );
    }

    await saveProgress(progressList);
  }

  Future<StudyProgress?> getTopicProgress(String topicId) async {
    final progressList = await loadProgress();
    try {
      return progressList.firstWhere((p) => p.topicId == topicId);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> getOverallStats() async {
    final progressList = await loadProgress();
    final completed = progressList.where((p) => p.isCompleted).length;
    final totalTime = progressList.fold<int>(0, (sum, p) => sum + p.timeSpent);

    return {
      'completedTopics': completed,
      'totalTime': totalTime,
      'totalTopics': progressList.length,
    };
  }

  Future<void> clearAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_progressKey);
  }

  // Concept tracking methods for syllabus tracker
  static const String _conceptsKey = 'completed_concepts';

  Future<Map<String, bool>> getCompletedConcepts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_conceptsKey);
    if (jsonString == null) return {};

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return jsonMap.map((key, value) => MapEntry(key, value as bool));
  }

  Future<void> saveCompletedConcept(String conceptId, bool isCompleted) async {
    final concepts = await getCompletedConcepts();
    concepts[conceptId] = isCompleted;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_conceptsKey, jsonEncode(concepts));
  }

  Future<void> clearAllConcepts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_conceptsKey);
  }
}
