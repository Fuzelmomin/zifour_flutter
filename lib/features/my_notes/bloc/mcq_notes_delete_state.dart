part of 'mcq_notes_delete_bloc.dart';

enum McqNotesDeleteStatus { initial, loading, success, failure }

class McqNotesDeleteState {
  final McqNotesDeleteStatus status;
  final McqNotesDeleteResponse? data;
  final String? errorMessage;

  const McqNotesDeleteState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory McqNotesDeleteState.initial() =>
      const McqNotesDeleteState(status: McqNotesDeleteStatus.initial);

  bool get isLoading => status == McqNotesDeleteStatus.loading;

  McqNotesDeleteState copyWith({
    McqNotesDeleteStatus? status,
    McqNotesDeleteResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return McqNotesDeleteState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

