class CourseDetailsModel {
  CourseDetailsModel({
      this.status, 
      this.message, 
      this.sampleTestChp, 
      this.packageDetails,});

  CourseDetailsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    sampleTestChp = json['sample_test_chp'];
    if (json['package_list'] != null) {
      packageDetails = [];
      json['package_list'].forEach((v) {
        packageDetails?.add(PackageDetailsItem.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  String? sampleTestChp;
  List<PackageDetailsItem>? packageDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['sample_test_chp'] = sampleTestChp;
    if (packageDetails != null) {
      map['package_list'] = packageDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class PackageDetailsItem {
  PackageDetailsItem({
      this.pkId, 
      this.name, 
      this.label, 
      this.oldPrice, 
      this.finalPrice, 
      this.discount, 
      this.standard, 
      this.medium, 
      this.exam, 
      this.totalTests, 
      this.totalVideo, 
      this.totalChapter, 
      this.description, 
      this.validity, 
      this.validTill, 
      this.pkImage,});

  PackageDetailsItem.fromJson(dynamic json) {
    pkId = json['pk_id'];
    name = json['name'];
    label = json['label'];
    oldPrice = json['old_price'];
    finalPrice = json['final_price'];
    discount = json['discount'];
    standard = json['standard'];
    medium = json['medium'];
    exam = json['exam'];
    totalTests = json['total_tests'];
    totalVideo = json['total_video'];
    totalChapter = json['total_chapter'];
    description = json['description'];
    validity = json['validity'];
    validTill = json['valid_till'];
    pkImage = json['pk_image'];
  }
  String? pkId;
  String? name;
  String? label;
  String? oldPrice;
  String? finalPrice;
  String? discount;
  String? standard;
  String? medium;
  String? exam;
  int? totalTests;
  int? totalVideo;
  int? totalChapter;
  String? description;
  String? validity;
  String? validTill;
  String? pkImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pk_id'] = pkId;
    map['name'] = name;
    map['label'] = label;
    map['old_price'] = oldPrice;
    map['final_price'] = finalPrice;
    map['discount'] = discount;
    map['standard'] = standard;
    map['medium'] = medium;
    map['exam'] = exam;
    map['total_tests'] = totalTests;
    map['total_video'] = totalVideo;
    map['total_chapter'] = totalChapter;
    map['description'] = description;
    map['validity'] = validity;
    map['valid_till'] = validTill;
    map['pk_image'] = pkImage;
    return map;
  }

}