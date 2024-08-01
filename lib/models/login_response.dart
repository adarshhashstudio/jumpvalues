class LoginResponseModel {
  LoginResponseModel(
      {this.status, this.flag, this.message, this.errors, this.data});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        status: json['status'] as bool?,
        flag: json['flag'] as String?,
        message: json['message'] as String?,
        errors: (json['errors'] as List<dynamic>?)
            ?.map((e) => ErrorModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        data: json['data'] != null ? Data.fromJson(json['data']) : null,
      );
  final bool? status;
  final String? flag;
  final String? message;
  List<ErrorModel>? errors;
  final Data? data;

  Map<String, dynamic> toJson() => {
        'status': status,
        'flag': flag,
        'message': message,
        'data': data?.toJson(),
      };
}

class Data {
  Data({this.token, this.role});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json['token'] as String?,
        role: json['role'] as String?,
      );
  final String? token;
  final String? role;

  Map<String, dynamic> toJson() => {
        'token': token,
        'role': role,
      };
}

class ErrorModel {
  ErrorModel({this.field, this.message});

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        field: json['field'],
        message: json['message'],
      );
  String? field;
  String? message;
}
