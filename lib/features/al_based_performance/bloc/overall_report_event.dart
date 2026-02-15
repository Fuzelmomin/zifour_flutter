part of 'overall_report_bloc.dart';

abstract class OverallReportEvent {
  const OverallReportEvent();
}

class FetchOverallReport extends OverallReportEvent {
  const FetchOverallReport();
}
