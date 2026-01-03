part of 'revision_bloc.dart';

abstract class RevisionEvent {
  const RevisionEvent();
}

class RevisionListRequested extends RevisionEvent {
  final bool forceRefresh;

  const RevisionListRequested({this.forceRefresh = false});
}

class RevisionItemDeleted extends RevisionEvent {
  final String plnrId;

  const RevisionItemDeleted({required this.plnrId});
}

class RevisionSubmitted extends RevisionEvent {
  final String stdId;
  final String exmId;
  final String subId;
  final String medId;
  final String chpId;
  final String tpcId;
  final String sDate;
  final String eDate;
  final String dHours;
  final String message;

  const RevisionSubmitted({
    required this.stdId,
    required this.exmId,
    required this.subId,
    required this.medId,
    required this.chpId,
    required this.tpcId,
    required this.sDate,
    required this.eDate,
    required this.dHours,
    required this.message,
  });
}
