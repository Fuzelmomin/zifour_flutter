part of 'challenge_details_bloc.dart';

abstract class ChallengeDetailsEvent {
  const ChallengeDetailsEvent();
}

class ChallengeDetailsRequested extends ChallengeDetailsEvent {
  final String crtChlId;

  const ChallengeDetailsRequested({required this.crtChlId});
}


