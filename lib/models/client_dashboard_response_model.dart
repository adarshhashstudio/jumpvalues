import 'package:jumpvalues/models/corevalues_response_model.dart';
import 'package:jumpvalues/models/tutorial_video_module.dart';

class ClientDashboardResponseModel {
  ClientDashboardResponseModel(
      {this.status, this.flag, this.message, this.data});

  // From JSON
  factory ClientDashboardResponseModel.fromJson(Map<String, dynamic> json) =>
      ClientDashboardResponseModel(
        status: json['status'] as bool?,
        flag: json['flag'] as String?,
        message: json['message'] as String?,
        data:
            json['data'] != null ? DashboardData.fromJson(json['data']) : null,
      );
  bool? status;
  String? flag;
  String? message;
  DashboardData? data;

  // To JSON
  Map<String, dynamic> toJson() => {
        'status': status,
        'flag': flag,
        'message': message,
        'data': data?.toJson(),
      };
}

class DashboardData {
  DashboardData({this.client});

  // From JSON
  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
        client: json['client'] != null ? Client.fromJson(json['client']) : null,
      );
  Client? client;

  // To JSON
  Map<String, dynamic> toJson() => {
        'client': client?.toJson(),
      };
}

class Client {
  Client(
      {this.id,
      this.firstName,
      this.lastName,
      this.consentRaised,
      this.coreValues,
      this.videos});

  // From JSON
  factory Client.fromJson(Map<String, dynamic> json) {
    var coreValuesList = json['core_values'] as List<dynamic>?;
    return Client(
      id: json['id'] as int?,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      consentRaised: json['consent_raised'] ?? false,
      coreValues: coreValuesList != null
          ? coreValuesList.map((item) => CoreValue.fromJson(item)).toList()
          : null,
      videos: json['videos'] != null ? Videos.fromJson(json['videos']) : null,
    );
  }
  int? id;
  String? firstName;
  String? lastName;
  bool? consentRaised;
  List<CoreValue>? coreValues;
  Videos? videos;

  // To JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'consent_raised': consentRaised,
        'core_values': coreValues?.map((item) => item.toJson()).toList(),
        'videos': videos?.toJson(),
      };
}
