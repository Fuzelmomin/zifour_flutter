part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeRequested extends HomeEvent {
  final bool forceRefresh;
  final Completer<void>? completer;

  const HomeRequested({
    this.forceRefresh = false,
    this.completer,
  });
}

