class CoursePackage {
  CoursePackage({
    required this.id,
    required this.name,
    required this.label,
    required this.oldPrice,
    required this.finalPrice,
    required this.discount,
    required this.standard,
    required this.medium,
    required this.exam,
    required this.totalTests,
    required this.totalVideo,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String label;
  final String oldPrice;
  final String finalPrice;
  final String discount;
  final String standard;
  final String medium;
  final String exam;
  final int totalTests;
  final int totalVideo;
  final String imageUrl;

  factory CoursePackage.fromJson(Map<String, dynamic> json) {
    return CoursePackage(
      id: (json['pk_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
      oldPrice: _normalizeCurrency(json['old_price']),
      finalPrice: _normalizeCurrency(json['final_price']),
      discount: (json['discount'] ?? '').toString(),
      standard: (json['standard'] ?? '').toString(),
      medium: (json['medium'] ?? '').toString(),
      exam: (json['exam'] ?? '').toString(),
      totalTests: _toInt(json['total_tests']),
      totalVideo: _toInt(json['total_video']),
      imageUrl: (json['pk_image'] ?? '').toString(),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is int) {
      return value;
    }
    return int.tryParse(value.toString()) ?? 0;
  }

  static String _normalizeCurrency(dynamic value) {
    final raw = (value ?? '').toString().trim();
    if (raw.isEmpty) {
      return '₹ 0';
    }
    return raw.replaceAll('&#8377;', '₹').replaceAll('&nbsp;', '').trim();
  }
}


