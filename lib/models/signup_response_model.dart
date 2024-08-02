class SignupResponseModel {
  SignupResponseModel({
    this.status,
    this.flag,
    this.message,
    this.errors,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) =>
      SignupResponseModel(
        status: json['status'] as bool?,
        flag: json['flag'] as String?,
        message: json['message'] as String?,
        errors: (json['errors'] as List<dynamic>?)
            ?.map((item) => ErrorDetail.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
  bool? status;
  String? flag;
  String? message;
  List<ErrorDetail>? errors;

  Map<String, dynamic> toJson() => {
        'status': status,
        'flag': flag,
        'message': message,
        'errors': errors?.map((e) => e.toJson()).toList(),
      };
}

class ErrorDetail {
  ErrorDetail({
    this.field,
    this.message,
  });

  factory ErrorDetail.fromJson(Map<String, dynamic> json) => ErrorDetail(
        field: json['field'] as String?,
        message: json['message'] as String?,
      );
  String? field;
  String? message;

  Map<String, dynamic> toJson() => {
        'field': field,
        'message': message,
      };
}
