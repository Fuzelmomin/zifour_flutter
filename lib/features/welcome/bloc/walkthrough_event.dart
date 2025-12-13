part of 'walkthrough_bloc.dart';

abstract class WalkthroughEvent {}

class WalkthroughRequested extends WalkthroughEvent {
  final String? medId;

  WalkthroughRequested({this.medId});
}

