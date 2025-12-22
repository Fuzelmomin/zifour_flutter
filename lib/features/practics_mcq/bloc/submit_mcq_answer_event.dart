part of 'submit_mcq_answer_bloc.dart';

abstract class SubmitMcqAnswerEvent {
  const SubmitMcqAnswerEvent();
}

class SubmitMcqAnswerRequested extends SubmitMcqAnswerEvent {
  final int crtChlId;
  final String apiType;
  final String? tpcId;
  final List<Map<String, String>> mcqList;

  const SubmitMcqAnswerRequested({
    required this.crtChlId,
    required this.mcqList,
    required this.apiType,
    this.tpcId,
  });
}

