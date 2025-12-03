part of 'challenge_mcq_list_bloc.dart';

abstract class ChallengeMcqListEvent {
  const ChallengeMcqListEvent();
}

class ChallengeMcqListRequested extends ChallengeMcqListEvent {
  final String crtChlId;

  const ChallengeMcqListRequested({required this.crtChlId});
}

