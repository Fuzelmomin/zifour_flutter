class MultimediaLibraryModel {
  bool? status;
  String? message;
  List<MultimediaLibraryItem>? multlibList;

  MultimediaLibraryModel({this.status, this.message, this.multlibList});

  MultimediaLibraryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['multlib_list'] != null) {
      multlibList = <MultimediaLibraryItem>[];
      json['multlib_list'].forEach((v) {
        multlibList!.add(MultimediaLibraryItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (multlibList != null) {
      data['multlib_list'] = multlibList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MultimediaLibraryItem {
  String? mulibId;
  String? name;
  String? description;

  MultimediaLibraryItem({this.mulibId, this.name, this.description});

  MultimediaLibraryItem.fromJson(Map<String, dynamic> json) {
    mulibId = json['mulib_id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mulib_id'] = mulibId;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}
