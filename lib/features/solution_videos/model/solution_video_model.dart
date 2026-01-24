import 'package:json_annotation/json_annotation.dart';

part 'solution_video_model.g.dart';

@JsonSerializable()
class SolutionVideoResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'genr_solution_list')
  final List<SolutionVideoModel> solutionList;

  SolutionVideoResponse({
    required this.status,
    required this.message,
    required this.solutionList,
  });

  factory SolutionVideoResponse.fromJson(Map<String, dynamic> json) =>
      _$SolutionVideoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SolutionVideoResponseToJson(this);
}

@JsonSerializable()
class SolutionVideoModel {
  @JsonKey(name: 'g_sl_id')
  final String gSlId;
  @JsonKey(name: 'solution_video')
  final String solutionVideo;

  SolutionVideoModel({
    required this.gSlId,
    required this.solutionVideo,
  });

  factory SolutionVideoModel.fromJson(Map<String, dynamic> json) =>
      _$SolutionVideoModelFromJson(json);

  Map<String, dynamic> toJson() => _$SolutionVideoModelToJson(this);
}

@JsonSerializable()
class ExpertSolutionVideoResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'exprt_solution_list')
  final List<ExpertSolutionVideoModel> solutionList;

  ExpertSolutionVideoResponse({
    required this.status,
    required this.message,
    required this.solutionList,
  });

  factory ExpertSolutionVideoResponse.fromJson(Map<String, dynamic> json) =>
      _$ExpertSolutionVideoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpertSolutionVideoResponseToJson(this);
}

@JsonSerializable()
class ExpertSolutionVideoModel {
  @JsonKey(name: 'crt_ch_sl_id')
  final String crtChSlId;
  @JsonKey(name: 'solution_video')
  final String solutionVideo;

  ExpertSolutionVideoModel({
    required this.crtChSlId,
    required this.solutionVideo,
  });

  factory ExpertSolutionVideoModel.fromJson(Map<String, dynamic> json) =>
      _$ExpertSolutionVideoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpertSolutionVideoModelToJson(this);
}
