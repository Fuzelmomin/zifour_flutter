part of 'mcq_notes_list_bloc.dart';

enum McqNotesListStatus { initial, loading, success, failure }

class McqNotesListState {
  final McqNotesListStatus status;
  final McqNotesListResponse? data;
  final String? errorMessage;

  const McqNotesListState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory McqNotesListState.initial() =>
      const McqNotesListState(status: McqNotesListStatus.initial);

  bool get isLoading => status == McqNotesListStatus.loading;
  bool get hasData => data != null && data!.mcqNotesList.isNotEmpty;

  McqNotesListState copyWith({
    McqNotesListStatus? status,
    McqNotesListResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return McqNotesListState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

