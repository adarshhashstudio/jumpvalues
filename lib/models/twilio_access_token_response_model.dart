class TwilioAccessTokenResponseModel {
  TwilioAccessTokenResponseModel({
    this.status,
    this.flag,
    this.message,
    this.token,
    this.roomId,
  });

  factory TwilioAccessTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      TwilioAccessTokenResponseModel(
        status: json['status'] as bool?,
        flag: json['flag'] as String?,
        message: json['message'] as String?,
        token: json['token'] as String?,
        roomId: json['room_id'] as String?,
      );
  final bool? status;
  final String? flag;
  final String? message;
  final String? token;
  final String? roomId;

  Map<String, dynamic> toJson() => {
        'status': status,
        'flag': flag,
        'message': message,
        'token': token,
        'room_id': roomId,
      };
}
