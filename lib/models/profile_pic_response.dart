class ProfilePictureResponse {
  ProfilePictureResponse({
    this.statusCode,
    this.responseCode,
    this.message,
    this.data,
  });

  factory ProfilePictureResponse.fromJson(Map<String, dynamic> json) =>
      ProfilePictureResponse(
        statusCode: json['statusCode'],
        responseCode: json['responseCode'],
        message: json['message'],
        data: json['data'],
      );
  int? statusCode;
  String? responseCode;
  String? message;
  String? data;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['responseCode'] = responseCode;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }
}
