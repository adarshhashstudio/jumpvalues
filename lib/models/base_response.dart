class BaseResponseModel {
  String? message;
  int? statusCode;

  BaseResponseModel({this.message, this.statusCode});

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) {
    return BaseResponseModel(
        message: json['message'], statusCode: json['statusCode']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['statusCode'] = statusCode;
    return data;
  }
}
