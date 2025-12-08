part of 'mcq_notes_bloc.dart';

enum McqNotesStatus { initial, loading, success, failure }

class McqNotesState {
  final McqNotesStatus status;
  final McqNotesResponse? data;
  final String? errorMessage;

  const McqNotesState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory McqNotesState.initial() =>
      const McqNotesState(status: McqNotesStatus.initial);

  bool get isLoading => status == McqNotesStatus.loading;

  McqNotesState copyWith({
    McqNotesStatus? status,
    McqNotesResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return McqNotesState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

