part of 'overall_report_bloc.dart';

enum OverallReportStatus { initial, loading, success, failure }

class OverallReportState {
  final OverallReportStatus status;
  final OverallReportModel? data;
  final String? errorMessage;

  const OverallReportState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory OverallReportState.initial() =>
      const OverallReportState(status: OverallReportStatus.initial);

  bool get isLoading => status == OverallReportStatus.loading;
  bool get isSuccess => status == OverallReportStatus.success;
  bool get isFailure => status == OverallReportStatus.failure;

  OverallReportState copyWith({
    OverallReportStatus? status,
    OverallReportModel? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OverallReportState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
