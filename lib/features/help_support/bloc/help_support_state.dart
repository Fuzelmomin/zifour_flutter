part of 'help_support_bloc.dart';

enum HelpSupportStatus { initial, loading, success, failure }

class HelpSupportState {
  final HelpSupportStatus status;
  final HelpSupportResponse? data;
  final String? errorMessage;

  const HelpSupportState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory HelpSupportState.initial() =>
      const HelpSupportState(status: HelpSupportStatus.initial);

  bool get isLoading => status == HelpSupportStatus.loading;

  HelpSupportState copyWith({
    HelpSupportStatus? status,
    HelpSupportResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HelpSupportState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
