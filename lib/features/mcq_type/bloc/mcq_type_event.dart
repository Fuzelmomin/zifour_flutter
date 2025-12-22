part of 'mcq_type_bloc.dart';

abstract class McqTypeEvent {
  const McqTypeEvent();
}

class McqTypeRequested extends McqTypeEvent {
  final bool silent;

  const McqTypeRequested({this.silent = false});
}
