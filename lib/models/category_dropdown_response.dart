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
  // Default to false

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as int?,
        name: json['name'] as String?,
        isSelected: json['isSelected'] as bool? ??
            false, // Optional, if you want to initialize from JSON
      ); // Add this line to include isSelected

  Category({this.id, this.name, this.isSelected = false});
  final int? id;
  final String? name;
  bool isSelected;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isSelected': isSelected, // Include isSelected in JSON
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
