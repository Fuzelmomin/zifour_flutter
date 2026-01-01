part of 'create_challenge_bloc.dart';

abstract class CreateChallengeEvent {
  const CreateChallengeEvent();
}

class CreateChallengeRequested extends CreateChallengeEvent {
  final List<String> chapterIds;
  final List<String> topicIds;
  final List<String> subIds;
  final String challengeType;

  const CreateChallengeRequested({
    required this.chapterIds,
    required this.topicIds,
    required this.subIds,
    required this.challengeType,
  });
}


