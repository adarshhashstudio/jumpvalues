import 'package:jumpvalues/models/requested_sessions_response_model.dart';
import 'package:jumpvalues/models/tutorial_video_module.dart';

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
