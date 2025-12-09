part of 'challenges_list_bloc.dart';

abstract class ChallengesListEvent {
  const ChallengesListEvent();
}

class ChallengesListRequested extends ChallengesListEvent {
  String challengeType;
  ChallengesListRequested({required this.challengeType});
}

