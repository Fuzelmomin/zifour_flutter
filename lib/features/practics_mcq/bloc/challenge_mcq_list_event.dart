part of 'challenge_mcq_list_bloc.dart';

abstract class ChallengeMcqListEvent {
  const ChallengeMcqListEvent();
}

class ChallengeMcqListRequested extends ChallengeMcqListEvent {
  final String crtChlId;

  final String apiType;
  final String? sampleTest;
  final String? topicId;
  final String? pkId;
  final String? paperId;

  const ChallengeMcqListRequested({
    required this.crtChlId,
    required this.apiType,
     this.sampleTest,
     this.topicId,
     this.pkId,
     this.paperId,
  });
}

