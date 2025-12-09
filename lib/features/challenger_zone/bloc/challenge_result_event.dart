part of 'challenge_result_bloc.dart';

abstract class ChallengeResultEvent {
  const ChallengeResultEvent();
}

class ChallengeResultRequested extends ChallengeResultEvent {
  final String crtChlId;

  const ChallengeResultRequested({
    required this.crtChlId,
  });
}
