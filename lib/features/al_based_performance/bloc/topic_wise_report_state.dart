part of 'topic_wise_report_bloc.dart';

enum TopicWiseReportStatus { initial, loading, success, failure }

class TopicWiseReportState {
  final TopicWiseReportStatus status;
  final TopicWiseReportModel? data;
  final String? errorMessage;

  const TopicWiseReportState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory TopicWiseReportState.initial() =>
      const TopicWiseReportState(status: TopicWiseReportStatus.initial);

  bool get isLoading => status == TopicWiseReportStatus.loading;
  bool get isSuccess => status == TopicWiseReportStatus.success;
  bool get isFailure => status == TopicWiseReportStatus.failure;

  TopicWiseReportState copyWith({
    TopicWiseReportStatus? status,
    TopicWiseReportModel? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TopicWiseReportState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
