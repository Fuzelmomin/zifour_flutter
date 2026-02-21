class TopicWiseReportModel {
  final bool status;
  final String? topicName;
  final TopicOverallPerformance? overallPerformance;
  final List<AccuracyProgress>? accuracyProgress;
  final DifficultyBreakdown? difficultyBreakdown;
  final List<String>? commonMistakes;
  final String? aiInsight;
  final String? aiSuggestion;

  TopicWiseReportModel({
    required this.status,
    this.topicName,
    this.overallPerformance,
    this.accuracyProgress,
    this.difficultyBreakdown,
    this.commonMistakes,
    this.aiInsight,
    this.aiSuggestion,
  });

  factory TopicWiseReportModel.fromJson(Map<String, dynamic> json) {
    return TopicWiseReportModel(
      status: json['status'] ?? false,
      topicName: json['tpc_name']?.toString(),
      overallPerformance: json['overall_performance'] != null
          ? TopicOverallPerformance.fromJson(json['overall_performance'])
          : null,
      accuracyProgress: json['accuracy_progress'] != null
          ? (json['accuracy_progress'] as List)
              .map((i) => AccuracyProgress.fromJson(i))
              .toList()
          : null,
      difficultyBreakdown: json['difficulty_breakdown'] != null
          ? DifficultyBreakdown.fromJson(json['difficulty_breakdown'])
          : null,
      commonMistakes: json['common_mistakes'] != null
          ? (json['common_mistakes'] as List).map((e) => e.toString()).toList()
          : null,
      aiInsight: json['ai_insight']?.toString(),
      aiSuggestion: json['ai_suggestion']?.toString(),
    );
  }
}

class TopicOverallPerformance {
  final int totalAttempted;
  final int correct;
  final int wrong;
  final int marks;
  final int accuracy;
  final String speed;

  TopicOverallPerformance({
    required this.totalAttempted,
    required this.correct,
    required this.wrong,
    required this.marks,
    required this.accuracy,
    required this.speed,
  });

  factory TopicOverallPerformance.fromJson(Map<String, dynamic> json) {
    return TopicOverallPerformance(
      totalAttempted: json['total_attempted'] ?? 0,
      correct: json['correct'] ?? 0,
      wrong: json['wrong'] ?? 0,
      marks: json['marks'] ?? 0,
      accuracy: json['accuracy'] ?? 0,
      speed: json['speed']?.toString() ?? 'N/A',
    );
  }
}

class AccuracyProgress {
  final String date;
  final double accuracy;

  AccuracyProgress({
    required this.date,
    required this.accuracy,
  });

  factory AccuracyProgress.fromJson(Map<String, dynamic> json) {
    return AccuracyProgress(
      date: json['date']?.toString() ?? '',
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0,
    );
  }
}

class DifficultyBreakdown {
  final int easy;
  final int medium;
  final int hard;

  DifficultyBreakdown({
    required this.easy,
    required this.medium,
    required this.hard,
  });

  factory DifficultyBreakdown.fromJson(Map<String, dynamic> json) {
    return DifficultyBreakdown(
      easy: json['Easy'] ?? 0,
      medium: json['Medium'] ?? 0,
      hard: json['Hard'] ?? 0,
    );
  }
}
