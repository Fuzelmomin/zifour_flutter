part of 'online_test_paper_bloc.dart';

abstract class OnlineTestPaperEvent {
  const OnlineTestPaperEvent();
}

class OnlineTestPaperRequested extends OnlineTestPaperEvent {
  final String pkId;
  const OnlineTestPaperRequested({required this.pkId});
}
