part of 'challenge_result_bloc.dart';

abstract class ChallengeResultEvent {
  const ChallengeResultEvent();
}

class ChallengeResultRequested extends ChallengeResultEvent {
  final String crtChlId;
  final String apiType;
  final String? pkId;
  final String? paperId;

  const ChallengeResultRequested({
    required this.crtChlId,
    required this.apiType,
    this.pkId,
    this.paperId,
  });
}
