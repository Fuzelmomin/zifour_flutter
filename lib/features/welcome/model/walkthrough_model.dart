class WalkthroughItem {
  final String wltId;
  final String name;
  final String description;
  final String? wltImage;
  final String? video;

  WalkthroughItem({
    required this.wltId,
    required this.name,
    required this.description,
    this.wltImage,
    this.video,
  });

  factory WalkthroughItem.fromJson(Map<String, dynamic> json) {
    return WalkthroughItem(
      wltId: json['wlt_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      wltImage: json['wlt_image']?.toString() ?? '',
      video: json['video']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wlt_id': wltId,
      'name': name,
      'description': description,
      'wlt_image': wltImage,
      'video': video,
    };
  }
}

class WalkthroughResponse {
  final bool status;
  final String message;
  final List<WalkthroughItem> walkthroughList;

  WalkthroughResponse({
    required this.status,
    required this.message,
    required this.walkthroughList,
  });

  factory WalkthroughResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> walkthroughListJson = json['walkthrough_list'] ?? [];
    final walkthroughList = walkthroughListJson
        .map((item) => WalkthroughItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return WalkthroughResponse(
      status: json['status'] ?? false,
      message: json['message']?.toString() ?? '',
      walkthroughList: walkthroughList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'walkthrough_list': walkthroughList.map((item) => item.toJson()).toList(),
    };
  }
}

