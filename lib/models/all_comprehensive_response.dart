class AllComprehensiveValues {
  int? statusCode;
  String? responseCode;
  String? message;
  List<ComprehensiveValues>? data;
  Pagination? pagination;

  AllComprehensiveValues({
    this.statusCode,
    this.responseCode,
    this.message,
    this.data,
    this.pagination,
  });

  factory AllComprehensiveValues.fromJson(Map<String, dynamic> json) {
    return AllComprehensiveValues(
      statusCode: json['statusCode'],
      responseCode: json['responseCode'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => ComprehensiveValues.fromJson(i)).toList()
          : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class ComprehensiveValues {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  ComprehensiveValues({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory ComprehensiveValues.fromJson(Map<String, dynamic> json) {
    return ComprehensiveValues(
      id: json['id'],
      name: json['name'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Pagination {
  int? totalItems;
  int? totalpage;
  int? currentPage;
  int? nextPage;
  int? previousPage;

  Pagination({
    this.totalItems,
    this.totalpage,
    this.currentPage,
    this.nextPage,
    this.previousPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalItems: json['totalItems'],
      totalpage: json['totalpage'],
      currentPage: json['currentPage'],
      nextPage: json['nextPage'],
      previousPage: json['previousPage'],
    );
  }
}
