part of 'topic_bloc.dart';

abstract class TopicEvent {
  const TopicEvent();
}

class TopicRequested extends TopicEvent {
  final List<String> chapterIds;
  final String? type;

  const TopicRequested({required this.chapterIds, this.type});
}


