class BaseResponseModel {
  BaseResponseModel({this.message, this.statusCode});

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) =>
      BaseResponseModel(
          message: json['message'], statusCode: json['statusCode']);
  String? message;
  int? statusCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['statusCode'] = statusCode;
    return data;
  }
}
