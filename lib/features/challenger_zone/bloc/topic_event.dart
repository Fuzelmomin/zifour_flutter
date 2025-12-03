part of 'topic_bloc.dart';

abstract class TopicEvent {
  const TopicEvent();
}

class TopicRequested extends TopicEvent {
  final List<String> chapterIds;

  const TopicRequested({required this.chapterIds});
}


