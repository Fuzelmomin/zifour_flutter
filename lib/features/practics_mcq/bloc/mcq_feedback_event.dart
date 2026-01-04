part of 'mcq_feedback_bloc.dart';

abstract class McqFeedbackEvent {}

class McqFeedbackRequested extends McqFeedbackEvent {
  final String mcqId;
  final String mcqType;
  final String mcqFdbTitle;
  final String mcqFdbDescription;

  McqFeedbackRequested({
    required this.mcqId,
    required this.mcqType,
    required this.mcqFdbTitle,
    required this.mcqFdbDescription,
  });
}
