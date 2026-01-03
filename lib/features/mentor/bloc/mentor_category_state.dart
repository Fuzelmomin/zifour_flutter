part of 'mentor_category_bloc.dart';

enum MentorCategoryStatus { initial, loading, success, failure }

class MentorCategoryState {
  final MentorCategoryStatus status;
  final MentorCategoryResponse? data;
  final String? errorMessage;

  const MentorCategoryState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory MentorCategoryState.initial() => const MentorCategoryState(
        status: MentorCategoryStatus.initial,
      );

  MentorCategoryState copyWith({
    MentorCategoryStatus? status,
    MentorCategoryResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MentorCategoryState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
