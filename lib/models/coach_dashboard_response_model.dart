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
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
        upcomingSessions: json['upcomingSessions'] as int?,
        todaySessions: json['todaySessions'] as int?,
        completedSessions: json['completedSessions'] as int?,
        recentRequests: (json['recentRequests'] as List<dynamic>?)
            ?.map((item) => RequestedSession.fromJson(
                item as Map<String, dynamic>))
            .toList(),
      );

  int? upcomingSessions;
  int? todaySessions;
  int? completedSessions;
  List<RequestedSession>? recentRequests;

  Map<String, dynamic> toJson() => {
        'upcomingSessions': upcomingSessions,
        'todaySessions': todaySessions,
        'completedSessions': completedSessions,
        'recentRequests':
            recentRequests?.map((session) => session.toJson()).toList(),
      };
}

// class DashboardRecentSessions {
//   DashboardRecentSessions({
//     this.id,
//     this.status,
//     this.userId,
//     this.userDp,
//     this.name,
//     this.startTime,
//     this.endTime,
//     this.remark,
//     this.date,
//   });

//   factory DashboardRecentSessions.fromJson(Map<String, dynamic> json) =>
//       DashboardRecentSessions(
//         id: json['id'] as int?,
//         status: json['status'] as int?,
//         userId: json['user_id'] as int?,
//         userDp: json['user_dp'] as String?,
//         name: json['name'] as String?,
//         startTime: json['start_time'] as String?,
//         endTime: json['end_time'] as String?,
//         remark: json['remark'] as String?,
//         date: json['date'] as String?,
//       );

//   int? id;
//   int? status;
//   int? userId;
//   String? userDp;
//   String? name;
//   String? startTime;
//   String? endTime;
//   String? remark;
//   String? date;

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'status': status,
//         'user_id': userId,
//         'user_dp': userDp,
//         'name': name,
//         'start_time': startTime,
//         'end_time': endTime,
//         'remark': remark,
//         'date': date,
//       };
// }
