part of 'revision_bloc.dart';

enum RevisionStatus { 
  initial, 
  loading, 
  success, 
  failure, 
  deleting, 
  deleteSuccess, 
  deleteFailure,
  submitting,
  submitSuccess,
  submitFailure 
}

class RevisionState {
  final RevisionStatus status;
  final RevisionResponse? data;
  final String? errorMessage;
  final String? deleteMessage;

  const RevisionState({
    required this.status,
    this.data,
    this.errorMessage,
    this.deleteMessage,
  });

  factory RevisionState.initial() => const RevisionState(
        status: RevisionStatus.initial,
      );

  RevisionState copyWith({
    RevisionStatus? status,
    RevisionResponse? data,
    String? errorMessage,
    String? deleteMessage,
    bool clearError = false,
  }) {
    return RevisionState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      deleteMessage: deleteMessage ?? this.deleteMessage,
    );
  }
}
