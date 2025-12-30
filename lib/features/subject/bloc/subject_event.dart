part of 'subject_bloc.dart';

abstract class SubjectEvent {
  const SubjectEvent();
}

class SubjectRequested extends SubjectEvent {
  final bool silent;
  final String? exmId;
  final bool updateService;

  const SubjectRequested({
    this.silent = false,
    this.exmId,
    this.updateService = true,
  });
}

