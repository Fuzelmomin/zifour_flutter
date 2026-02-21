class SubjectWiseReportModel {
  final bool status;
  final SubjectOverallPerformance? overallPerformance;
  final String? aiInsight;
  final List<SubjectTopicPerformance>? topicWisePerformance;
  final String? aiSuggestion;

  SubjectWiseReportModel({
    required this.status,
    this.overallPerformance,
    this.aiInsight,
    this.topicWisePerformance,
    this.aiSuggestion,
  });

  factory SubjectWiseReportModel.fromJson(Map<String, dynamic> json) {
    return SubjectWiseReportModel(
      status: json['status'] ?? false,
      overallPerformance: json['overall_performance'] != null
          ? SubjectOverallPerformance.fromJson(json['overall_performance'])
          : null,
      aiInsight: json['ai_insight']?.toString(),
      topicWisePerformance: json['topic_wise_performance'] != null
          ? (json['topic_wise_performance'] as List)
              .map((i) => SubjectTopicPerformance.fromJson(i))
              .toList()
          : null,
      aiSuggestion: json['ai_suggestion']?.toString(),
    );
  }
}

class SubjectOverallPerformance {
  final int totalAttempted;
  final int accuracy;
  final String speed;
  final String trend;

  SubjectOverallPerformance({
    required this.totalAttempted,
    required this.accuracy,
    required this.speed,
    required this.trend,
  });

  factory SubjectOverallPerformance.fromJson(Map<String, dynamic> json) {
    return SubjectOverallPerformance(
      totalAttempted: json['total_attempted'] ?? 0,
      accuracy: json['accuracy'] ?? 0,
      speed: json['speed']?.toString() ?? 'N/A',
      trend: json['trend']?.toString() ?? 'Stable',
    );
  }
}

class SubjectTopicPerformance {
  final String topicId;
  final String topicName;
  final String totalQuestions;
  final String correct;
  final dynamic wrong;
  final String accuracy;
  final String level;

  SubjectTopicPerformance({
    required this.topicId,
    required this.topicName,
    required this.totalQuestions,
    required this.correct,
    required this.wrong,
    required this.accuracy,
    required this.level,
  });

  factory SubjectTopicPerformance.fromJson(Map<String, dynamic> json) {
    return SubjectTopicPerformance(
      topicId: json['topic_id']?.toString() ?? '',
      topicName: json['topic_name']?.toString() ?? '',
      totalQuestions: json['total_questions']?.toString() ?? '0',
      correct: json['correct']?.toString() ?? '0',
      wrong: json['wrong'],
      accuracy: json['accuracy']?.toString() ?? '0',
      level: json['level']?.toString() ?? '',
    );
  }
}
