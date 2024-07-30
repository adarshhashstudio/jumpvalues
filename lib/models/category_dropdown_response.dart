class CategoryDropdownResponse {
  factory CategoryDropdownResponse.fromJson(Map<String, dynamic> json) =>
      CategoryDropdownResponse(
        status: json['status'] as bool?,
        flag: json['flag'] as String?,
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((item) => Category.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

  CategoryDropdownResponse({
    this.status,
    this.flag,
    this.message,
    this.data,
  });
  final bool? status;
  final String? flag;
  final String? message;
  final List<Category>? data;

  Map<String, dynamic> toJson() => {
        'status': status,
        'flag': flag,
        'message': message,
        'data': data?.map((item) => item.toJson()).toList(),
      };
}

class Category {
  Category({
    this.id,
    this.name,
    this.isSelected = false,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as int?,
        name: json['name'] as String?,
        isSelected: false,
      );
  final int? id;
  final String? name;
  bool isSelected;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isSelected': isSelected,
      };
}
