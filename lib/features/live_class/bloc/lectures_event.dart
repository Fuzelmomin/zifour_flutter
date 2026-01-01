part of 'lectures_bloc.dart';

sealed class LecturesEvent {}

class FetchLectures extends LecturesEvent {
  FetchLectures({
    this.chpId,
    this.tpcId,
    this.subId,
    this.stuId,
    this.medId,
    this.exmId,
    this.lvCls,
    this.lecSample,
    this.lecRept,
  });

  final String? chpId;
  final String? tpcId;
  final String? subId;
  final String? stuId;
  final String? medId;
  final String? exmId;
  final String? lvCls;
  final String? lecSample;
  final String? lecRept;
}

class UpdateLectureReminder extends LecturesEvent {
  UpdateLectureReminder({required this.lecId});

  final String lecId;
}

