class NotificationResponseModel {
  // From JSON
  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) =>
      NotificationResponseModel(
        status: json['status'] as bool?,
        flag: json['flag'] as String?,
        message: json['message'] as String?,
        pageDetails: json['page_details'] != null
            ? PageDetails.fromJson(json['page_details'])
            : null,
        data: json['data'] != null
            ? (json['data'] as List)
                .map((item) => NotificationData.fromJson(item))
                .toList()
            : null,
      );

  NotificationResponseModel({
    this.status,
    this.flag,
    this.message,
    this.pageDetails,
    this.data,
  });
  bool? status;
  String? flag;
  String? message;
  PageDetails? pageDetails;
  List<NotificationData>? data;

  // To JSON
  Map<String, dynamic> toJson() => {
        'status': status,
        'flag': flag,
        'message': message,
        'page_details': pageDetails?.toJson(),
        'data': data?.map((item) => item.toJson()).toList(),
      };
}

class PageDetails {
  PageDetails({this.page, this.limit, this.noOfRecords});

  // From JSON
  factory PageDetails.fromJson(Map<String, dynamic> json) => PageDetails(
        page: json['page'] as int?,
        limit: json['limit'] as int?,
        noOfRecords: json['no_of_records'] as int?,
      );
  int? page;
  int? limit;
  int? noOfRecords;

  // To JSON
  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        'no_of_records': noOfRecords,
      };
}

class NotificationData {
  NotificationData({
    this.id,
    this.title,
    this.message,
    this.isRead,
    this.createdAt,
  });

  // From JSON
  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json['id'] as int?,
        title: json['title'] as String?,
        message: json['message'] as String?,
        isRead: json['is_read'] as int?,
        createdAt: json['created_at'] as String?,
      );
  int? id;
  String? title;
  String? message;
  int? isRead;
  String? createdAt;

  // To JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'is_read': isRead,
        'created_at': createdAt,
      };
}
