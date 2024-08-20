class RequestedSessionsResponseModel {
  RequestedSessionsResponseModel({
    this.status,
    this.flag,
    this.message,
    this.pageDetails,
    this.data,
  });

  // Create a factory constructor for creating an instance from JSON
  factory RequestedSessionsResponseModel.fromJson(Map<String, dynamic> json) =>
      RequestedSessionsResponseModel(
        status: json['status'] as bool?,
        flag: json['flag'] as String?,
        message: json['message'] as String?,
        pageDetails: json['page_details'] != null
            ? PageDetails.fromJson(json['page_details'] as Map<String, dynamic>)
            : null,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => RequestedSession.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
  bool? status;
  String? flag;
  String? message;
  PageDetails? pageDetails;
  List<RequestedSession>? data;

  // Convert the instance to JSON
  Map<String, dynamic> toJson() => {
        'status': status,
        'flag': flag,
        'message': message,
        'page_details': pageDetails?.toJson(),
        'data': data?.map((e) => e.toJson()).toList(),
      };
}

// Define the PageDetails class
class PageDetails {
  PageDetails({
    this.page,
    this.limit,
    this.noOfRecords,
  });

  factory PageDetails.fromJson(Map<String, dynamic> json) => PageDetails(
        page: json['page'] as int?,
        limit: json['limit'] as int?,
        noOfRecords: json['no_of_records'] as int?,
      );
  int? page;
  int? limit;
  int? noOfRecords;

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        'no_of_records': noOfRecords,
      };
}

// Define the RequestedSession class
class RequestedSession {
  RequestedSession({
    this.id,
    this.status,
    this.userId,
    this.userDp,
    this.name,
    this.startTime,
    this.endTime,
    this.remark,
    this.date,
    this.rating,
  });

  factory RequestedSession.fromJson(Map<String, dynamic> json) =>
      RequestedSession(
        id: json['id'] as int?,
        status: json['status'] as int?,
        userId: json['user_id'] as int?,
        userDp: json['user_dp'] as String?,
        name: json['name'] as String?,
        startTime: json['start_time'] as String?,
        endTime: json['end_time'] as String?,
        remark: json['remark'] as String?,
        date: json['date'] as String?,
        rating: json['rating'] as String?,
      );
  int? id;
  int? status;
  int? userId;
  String? userDp;
  String? name;
  String? startTime;
  String? endTime;
  String? remark;
  String? date;
  String? rating;

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'user_id': userId,
        'user_dp': userDp,
        'name': name,
        'start_time': startTime,
        'end_time': endTime,
        'remark': remark,
        'date': date,
        'rating': rating,
      };
}
