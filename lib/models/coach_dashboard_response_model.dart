import 'package:jumpvalues/models/requested_sessions_response_model.dart';

class CoachDashboardResponseModel {
  CoachDashboardResponseModel({
    this.status,
    this.flag,
    this.message,
    this.data,
  });

  factory CoachDashboardResponseModel.fromJson(Map<String, dynamic> json) =>
      CoachDashboardResponseModel(
        status: json['status'] as bool?,
        flag: json['flag'] as String?,
        message: json['message'] as String?,
        data: json['data'] != null
            ? DashboardData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );

  bool? status;
  String? flag;
  String? message;
  DashboardData? data;

  Map<String, dynamic> toJson() => {
        'status': status,
        'flag': flag,
        'message': message,
        'data': data?.toJson(),
      };
}

class DashboardData {
  DashboardData({
    this.upcomingSessions,
    this.todaySessions,
    this.completedSessions,
    this.recentRequests,
    this.videos,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
        upcomingSessions: json['upcomingSessions'] as int?,
        todaySessions: json['todaySessions'] as int?,
        completedSessions: json['completedSessions'] as int?,
        recentRequests: (json['recentRequests'] as List<dynamic>?)
            ?.map((item) =>
                RequestedSession.fromJson(item as Map<String, dynamic>))
            .toList(),
        videos: json['videos'] != null ? Videos.fromJson(json['videos']) : null,
      );

  int? upcomingSessions;
  int? todaySessions;
  int? completedSessions;
  List<RequestedSession>? recentRequests;
  Videos? videos;

  Map<String, dynamic> toJson() => {
        'upcomingSessions': upcomingSessions,
        'todaySessions': todaySessions,
        'completedSessions': completedSessions,
        'recentRequests':
            recentRequests?.map((session) => session.toJson()).toList(),
        'videos': videos?.toJson(),
      };
}

class Videos {
  Videos({this.count, this.rows});

  // From JSON
  factory Videos.fromJson(Map<String, dynamic> json) {
    var rowsList = json['rows'] as List<dynamic>?;
    return Videos(
      count: json['count'] as int?,
      rows: rowsList != null
          ? rowsList.map((item) => VideoRow.fromJson(item)).toList()
          : null,
    );
  }
  int? count;
  List<VideoRow>? rows;

  // To JSON
  Map<String, dynamic> toJson() => {
        'count': count,
        'rows': rows?.map((item) => item.toJson()).toList(),
      };
}

class VideoRow {
  VideoRow({
    this.id,
    this.title,
    this.slug,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  // From JSON
  factory VideoRow.fromJson(Map<String, dynamic> json) => VideoRow(
        id: json['id'] as int?,
        title: json['title'] as String?,
        slug: json['slug'] as String?,
        url: json['URL'] as String?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
      );
  int? id;
  String? title;
  String? slug;
  String? url;
  String? createdAt;
  String? updatedAt;

  // To JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'slug': slug,
        'URL': url,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
