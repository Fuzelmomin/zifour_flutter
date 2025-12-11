import 'dart:io';

abstract class DoubtEvent {}

class UploadDoubtImage extends DoubtEvent {
  final File imageFile;

  UploadDoubtImage(this.imageFile);
}

class SubmitDoubt extends DoubtEvent {
  final String stuId;
  final String stdId;
  final String exmId;
  final String subId;
  final String medId;
  final String dbtMessage;
  final String? dbtAttachment;

  SubmitDoubt({
    required this.stuId,
    required this.stdId,
    required this.exmId,
    required this.subId,
    required this.medId,
    required this.dbtMessage,
    this.dbtAttachment,
  });
}

class ResetDoubtState extends DoubtEvent {}

