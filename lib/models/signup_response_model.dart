class SignupResponseModel {
  bool? status;
  String? flag;
  String? message;
  List<ErrorDetail>? errors;

  SignupResponseModel({
    this.status,
    this.flag,
    this.message,
    this.errors,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      status: json['status'] as bool?,
      flag: json['flag'] as String?,
      message: json['message'] as String?,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((item) => ErrorDetail.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'flag': flag,
      'message': message,
      'errors': errors?.map((e) => e.toJson()).toList(),
    };
  }
}

class ErrorDetail {
  String? field;
  String? message;

  ErrorDetail({
    this.field,
    this.message,
  });

  factory ErrorDetail.fromJson(Map<String, dynamic> json) {
    return ErrorDetail(
      field: json['field'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'message': message,
    };
  }
}
