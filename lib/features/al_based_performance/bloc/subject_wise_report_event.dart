part of 'subject_wise_report_bloc.dart';

abstract class SubjectWiseReportEvent {
  const SubjectWiseReportEvent();
}

class FetchSubjectWiseReport extends SubjectWiseReportEvent {
  final String subjectId;
  const FetchSubjectWiseReport({required this.subjectId});
}
