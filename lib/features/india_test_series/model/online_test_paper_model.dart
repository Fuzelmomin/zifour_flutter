import 'package:json_annotation/json_annotation.dart';

part 'online_test_paper_model.g.dart';

@JsonSerializable()
class OnlineTestPaperResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'general_paper_list')
  final List<TestPaperModel> generalPaperList;

  OnlineTestPaperResponse({
    required this.status,
    required this.message,
    required this.generalPaperList,
  });

  factory OnlineTestPaperResponse.fromJson(Map<String, dynamic> json) =>
      _$OnlineTestPaperResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineTestPaperResponseToJson(this);
}

@JsonSerializable()
class TestPaperModel {
  @JsonKey(name: 'g_pa_id')
  final String gPaId;
  @JsonKey(name: 'g_pa_name')
  final String gPaName;

  final String date;
  final String time;

  @JsonKey(name: 'solution_video')
  final String solutionVideo;

  @JsonKey(name: 'er_flag')
  final String erFlag;

  TestPaperModel({
    required this.gPaId,
    required this.gPaName,
    required this.date,
    required this.time,
    required this.solutionVideo,
    required this.erFlag,
  });

  factory TestPaperModel.fromJson(Map<String, dynamic> json) =>
      _$TestPaperModelFromJson(json);

  Map<String, dynamic> toJson() => _$TestPaperModelToJson(this);
}
