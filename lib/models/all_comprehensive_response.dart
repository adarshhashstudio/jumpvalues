import 'package:jumpvalues/models/corevalues_response_model.dart';

class AllComprehensiveValues {
  AllComprehensiveValues({this.status, this.flag, this.message, this.data});

  factory AllComprehensiveValues.fromJson(Map<String, dynamic> json) =>
      AllComprehensiveValues(
        status: json['status'],
        flag: json['flag'],
        message: json['message'],
        data: (json['data'] as List?)
            ?.map((item) => CoreValue.fromJson(item))
            .toList(),
      );
  bool? status;
  String? flag;
  String? message;
  List<CoreValue>? data;

  Map<String, dynamic> toJson() => {
        'status': status,
        'flag': flag,
        'message': message,
        'data': data?.map((item) => item.toJson()).toList(),
      };
}
