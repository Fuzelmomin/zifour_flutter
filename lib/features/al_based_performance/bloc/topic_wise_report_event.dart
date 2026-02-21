part of 'topic_wise_report_bloc.dart';

abstract class TopicWiseReportEvent {
  const TopicWiseReportEvent();
}

class FetchTopicWiseReport extends TopicWiseReportEvent {
  final String topicId;
  const FetchTopicWiseReport({required this.topicId});
}
