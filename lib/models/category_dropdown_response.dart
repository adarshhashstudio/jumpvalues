class CategoryDropdownResponse {
  final bool? status;
  final String? flag;
  final String? message;
  final List<Category>? data;

  CategoryDropdownResponse({
    this.status,
    this.flag,
    this.message,
    this.data,
  });

  factory CategoryDropdownResponse.fromJson(Map<String, dynamic> json) {
    return CategoryDropdownResponse(
      status: json['status'] as bool?,
      flag: json['flag'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'flag': flag,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class Category {
  final int? id;
  final String? name;
  bool isSelected;

  Category({
    this.id,
    this.name,
    this.isSelected = false,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int?,
      name: json['name'] as String?,
      isSelected: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isSelected': isSelected,
    };
  }
}
