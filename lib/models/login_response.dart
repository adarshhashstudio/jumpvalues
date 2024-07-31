class LoginResponseModel {
  LoginResponseModel({this.status, this.flag, this.message, this.data});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        status: json['status'] as bool?,
        flag: json['flag'] as String?,
        message: json['message'] as String?,
        data: json['data'] != null ? Data.fromJson(json['data']) : null,
      );
  final bool? status;
  final String? flag;
  final String? message;
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
