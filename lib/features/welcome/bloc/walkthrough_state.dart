part of 'walkthrough_bloc.dart';

enum WalkthroughStatus {
  initial,
  loading,
  success,
  failure,
}

class WalkthroughState {
  final WalkthroughStatus status;
  final WalkthroughResponse? data;
  final String? errorMessage;

  WalkthroughState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory WalkthroughState.initial() {
    return WalkthroughState(
      status: WalkthroughStatus.initial,
    );
  }

  WalkthroughState copyWith({
    WalkthroughStatus? status,
    WalkthroughResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return WalkthroughState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get hasData => data != null && data!.walkthroughList.isNotEmpty;
}

