part of 'topic_bloc.dart';

enum TopicStatus { initial, loading, success, failure }

class TopicState {
  final TopicStatus status;
  final TopicResponse? data;
  final String? errorMessage;

  const TopicState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory TopicState.initial() => const TopicState(status: TopicStatus.initial);

  bool get isLoading => status == TopicStatus.loading;
  bool get hasData => data != null && data!.topicList.isNotEmpty;

  TopicState copyWith({
    TopicStatus? status,
    TopicResponse? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TopicState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}


