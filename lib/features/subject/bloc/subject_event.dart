part of 'subject_bloc.dart';

abstract class SubjectEvent {
  const SubjectEvent();
}

class SubjectRequested extends SubjectEvent {
  final bool silent;
  
  const SubjectRequested({this.silent = false});
}

