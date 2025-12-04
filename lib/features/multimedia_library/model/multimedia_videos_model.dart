class MultimediaVideosModel {
  bool? status;
  String? message;
  List<MultimediaVideoItem>? multvidList;

  MultimediaVideosModel({this.status, this.message, this.multvidList});

  MultimediaVideosModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['multvid_list'] != null) {
      multvidList = <MultimediaVideoItem>[];
      json['multvid_list'].forEach((v) {
        multvidList!.add(MultimediaVideoItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (multvidList != null) {
      data['multvid_list'] = multvidList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MultimediaVideoItem {
  String? mutvidId;
  String? name;
  String? youtubeCode;

  MultimediaVideoItem({this.mutvidId, this.name, this.youtubeCode});

  MultimediaVideoItem.fromJson(Map<String, dynamic> json) {
    mutvidId = json['mutvid_id'];
    name = json['name'];
    youtubeCode = json['youtube_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mutvid_id'] = mutvidId;
    data['name'] = name;
    data['youtube_code'] = youtubeCode;
    return data;
  }
}
