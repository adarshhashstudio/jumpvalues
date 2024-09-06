import 'package:jumpvalues/models/corevalues_response_model.dart';

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
      {this.id, this.firstName, this.lastName, this.coreValues, this.videos});

  // From JSON
  factory Client.fromJson(Map<String, dynamic> json) {
    var coreValuesList = json['core_values'] as List<dynamic>?;
    return Client(
      id: json['id'] as int?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      coreValues: coreValuesList != null
          ? coreValuesList.map((item) => CoreValue.fromJson(item)).toList()
          : null,
      videos: json['videos'] != null ? Videos.fromJson(json['videos']) : null,
    );
  }
  int? id;
  String? firstName;
  String? lastName;
  List<CoreValue>? coreValues;
  Videos? videos;

  // To JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'core_values': coreValues?.map((item) => item.toJson()).toList(),
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
