part of 'subject_wise_report_bloc.dart';

enum SubjectWiseReportStatus { initial, loading, success, failure }

class SubjectWiseReportState {
  final SubjectWiseReportStatus status;
  final SubjectWiseReportModel? data;
  final String? errorMessage;

  const SubjectWiseReportState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory SubjectWiseReportState.initial() =>
      const SubjectWiseReportState(status: SubjectWiseReportStatus.initial);

  bool get isLoading => status == SubjectWiseReportStatus.loading;
  bool get isSuccess => status == SubjectWiseReportStatus.success;
  bool get isFailure => status == SubjectWiseReportStatus.failure;

  SubjectWiseReportState copyWith({
    SubjectWiseReportStatus? status,
    SubjectWiseReportModel? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SubjectWiseReportState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
