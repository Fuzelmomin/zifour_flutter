class OverallReportModel {
  final bool status;
  final String message;
  final OverallStats? overall;
  final List<SubjectAnalysis>? subjects;
  final List<ChapterAnalysis>? chapters;
  final List<TopicAnalysis>? topics;

  OverallReportModel({
    required this.status,
    required this.message,
    this.overall,
    this.subjects,
    this.chapters,
    this.topics,
  });

  factory OverallReportModel.fromJson(Map<String, dynamic> json) {
    return OverallReportModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      overall: json['overall'] != null ? OverallStats.fromJson(json['overall']) : null,
      subjects: json['subjects'] != null
          ? (json['subjects'] as List).map((i) => SubjectAnalysis.fromJson(i)).toList()
          : null,
      chapters: json['chapters'] != null
          ? (json['chapters'] as List).map((i) => ChapterAnalysis.fromJson(i)).toList()
          : null,
      topics: json['topics'] != null
          ? (json['topics'] as List).map((i) => TopicAnalysis.fromJson(i)).toList()
          : null,
    );
  }
}

class OverallStats {
  final int totalQuestions;
  final int correct;
  final int wrong;
  final int unattempted;
  final int marks;
  final String accuracy;
  final String trend;

  OverallStats({
    required this.totalQuestions,
    required this.correct,
    required this.wrong,
    required this.unattempted,
    required this.marks,
    required this.accuracy,
    required this.trend,
  });

  factory OverallStats.fromJson(Map<String, dynamic> json) {
    return OverallStats(
      totalQuestions: json['total_questions'] ?? 0,
      correct: json['correct'] ?? 0,
      wrong: json['wrong'] ?? 0,
      unattempted: json['unattempted'] ?? 0,
      marks: json['marks'] ?? 0,
      accuracy: json['accuracy']?.toString() ?? '0.00',
      trend: json['trend'] ?? '',
    );
  }
}

class SubjectAnalysis {
  final String subjectId;
  final String subjectName;
  final String totalQuestions;
  final String correct;
  final dynamic wrong; // Can be String or int based on JSON
  final String accuracy;

  SubjectAnalysis({
    required this.subjectId,
    required this.subjectName,
    required this.totalQuestions,
    required this.correct,
    required this.wrong,
    required this.accuracy,
  });

  factory SubjectAnalysis.fromJson(Map<String, dynamic> json) {
    return SubjectAnalysis(
      subjectId: json['subject_id']?.toString() ?? '',
      subjectName: json['subject_name'] ?? '',
      totalQuestions: json['total_questions']?.toString() ?? '0',
      correct: json['correct']?.toString() ?? '0',
      wrong: json['wrong'],
      accuracy: json['accuracy']?.toString() ?? '0.00',
    );
  }
}

class ChapterAnalysis {
  final String chapterId;
  final String chapterName;
  final String totalQuestions;
  final String correct;
  final dynamic wrong;
  final String accuracy;
  final String level;

  ChapterAnalysis({
    required this.chapterId,
    required this.chapterName,
    required this.totalQuestions,
    required this.correct,
    required this.wrong,
    required this.accuracy,
    required this.level,
  });

  factory ChapterAnalysis.fromJson(Map<String, dynamic> json) {
    return ChapterAnalysis(
      chapterId: json['chapter_id']?.toString() ?? '',
      chapterName: json['chapter_name'] ?? '',
      totalQuestions: json['total_questions']?.toString() ?? '0',
      correct: json['correct']?.toString() ?? '0',
      wrong: json['wrong'],
      accuracy: json['accuracy']?.toString() ?? '0.00',
      level: json['level'] ?? '',
    );
  }
}

class TopicAnalysis {
  final String topicId;
  final String topicName;

  TopicAnalysis({
    required this.topicId,
    required this.topicName,
  });

  factory TopicAnalysis.fromJson(Map<String, dynamic> json) {
    return TopicAnalysis(
      topicId: json['topic_id']?.toString() ?? '',
      topicName: json['topic_name'] ?? '',
    );
  }
}
