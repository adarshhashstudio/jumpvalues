class BaseResponseModel {
  factory BaseResponseModel.fromJson(Map<String, dynamic> json) =>
      BaseResponseModel(
        status: json['status'],
        flag: json['flag'],
        message: json['message'],
        errors: (json['errors'] as List<dynamic>?)
            ?.map((e) => ErrorModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  BaseResponseModel({this.status, this.flag, this.message, this.errors});
  bool? status;
  String? flag;
  String? message;
  List<ErrorModel>? errors;
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
