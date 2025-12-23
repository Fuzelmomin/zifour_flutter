part of 'online_test_paper_bloc.dart';

enum OnlineTestPaperStatus { initial, loading, success, failure }

class OnlineTestPaperState {
  final OnlineTestPaperStatus status;
  final OnlineTestPaperResponse? data;
  final String? errorMessage;

  const OnlineTestPaperState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory OnlineTestPaperState.initial() =>
      const OnlineTestPaperState(status: OnlineTestPaperStatus.initial);

  bool get isLoading => status == OnlineTestPaperStatus.loading;
  bool get hasData => data != null && data!.generalPaperList.isNotEmpty;

  OnlineTestPaperState copyWith({
    OnlineTestPaperStatus? status,
    OnlineTestPaperResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OnlineTestPaperState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
