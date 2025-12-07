part of 'update_challenge_bloc.dart';

abstract class UpdateChallengeEvent {
  const UpdateChallengeEvent();
}

class UpdateChallengeRequested extends UpdateChallengeEvent {
  final int crtChlId;
  final List<String> chapterIds;
  final List<String> topicIds;
  final String subId;

  const UpdateChallengeRequested({
    required this.crtChlId,
    required this.chapterIds,
    required this.topicIds,
    required this.subId,
  });
}

