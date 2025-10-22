class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? icon;
  final String? color;
  final int sortOrder;
  final int articlesCount;
  final Map<String, dynamic>? metadata;
  final String createdAt;
  final String updatedAt;
  final List<SubCategoryModel> subCategory;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    this.color,
    required this.sortOrder,
    required this.articlesCount,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    required this.subCategory,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      sortOrder: json['sort_order'] ?? 0,
      articlesCount: json['articles_count'] ?? 0,
      metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata']) : null,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      subCategory: (json['subCategory'] as List<dynamic>?)
          ?.map((sub) => SubCategoryModel.fromJson(sub))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'icon': icon,
      'color': color,
      'sort_order': sortOrder,
      'articles_count': articlesCount,
      'metadata': metadata,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'subCategory': subCategory.map((sub) => sub.toJson()).toList(),
    };
  }

  CategoryModel copyWith({
    int? id,
    String? name,
    String? slug,
    String? description,
    String? icon,
    String? color,
    int? sortOrder,
    int? articlesCount,
    Map<String, dynamic>? metadata,
    String? createdAt,
    String? updatedAt,
    List<SubCategoryModel>? subCategory,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      articlesCount: articlesCount ?? this.articlesCount,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subCategory: subCategory ?? this.subCategory,
    );
  }
}

class SubCategoryModel {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? icon;
  final String? color;
  final int sortOrder;
  final int articlesCount;
  final Map<String, dynamic>? metadata;
  final String createdAt;
  final String updatedAt;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    this.color,
    required this.sortOrder,
    required this.articlesCount,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      sortOrder: json['sort_order'] ?? 0,
      articlesCount: json['articles_count'] ?? 0,
      metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata']) : null,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'icon': icon,
      'color': color,
      'sort_order': sortOrder,
      'articles_count': articlesCount,
      'metadata': metadata,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  SubCategoryModel copyWith({
    int? id,
    String? name,
    String? slug,
    String? description,
    String? icon,
    String? color,
    int? sortOrder,
    int? articlesCount,
    Map<String, dynamic>? metadata,
    String? createdAt,
    String? updatedAt,
  }) {
    return SubCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      articlesCount: articlesCount ?? this.articlesCount,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CategoriesResponseModel {
  final List<CategoryModel> data;

  CategoriesResponseModel({
    required this.data,
  });

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoriesResponseModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((category) => CategoryModel.fromJson(category))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((category) => category.toJson()).toList(),
    };
  }
}

