class AllComprehensiveValues {
  bool? status;
  String? flag;
  String? message;
  List<ComprehensiveValues>? data;

  AllComprehensiveValues({this.status, this.flag, this.message, this.data});

  factory AllComprehensiveValues.fromJson(Map<String, dynamic> json) {
    return AllComprehensiveValues(
      status: json['status'],
      flag: json['flag'],
      message: json['message'],
      data: (json['data'] as List?)?.map((item) => ComprehensiveValues.fromJson(item)).toList(),
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

class ComprehensiveValues {
  int? id;
  String? name;

  ComprehensiveValues({this.id, this.name});

  factory ComprehensiveValues.fromJson(Map<String, dynamic> json) {
    return ComprehensiveValues(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
