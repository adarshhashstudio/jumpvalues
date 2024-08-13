import 'package:jumpvalues/models/corevalues_response_model.dart';

class ClientDashboardResponseModel {
  ClientDashboardResponseModel({
    this.status,
    this.flag,
    this.message,
    this.data,
  });

  factory ClientDashboardResponseModel.fromJson(Map<String, dynamic> json) =>
      ClientDashboardResponseModel(
        status: json['status'],
        flag: json['flag'],
        message: json['message'],
        data:
            json['data'] != null ? DashboardData.fromJson(json['data']) : null,
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
  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        coreValues: json['core_values'] != null
            ? (json['core_values'] as List)
                .map((item) => CoreValue.fromJson(item))
                .toList()
            : null,
      );

  DashboardData({
    this.id,
    this.firstName,
    this.lastName,
    this.coreValues,
  });
  int? id;
  String? firstName;
  String? lastName;
  List<CoreValue>? coreValues;

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'core_values': coreValues?.map((item) => item.toJson()).toList(),
      };
}
