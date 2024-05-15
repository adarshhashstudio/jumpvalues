class SignupResponseModel {
  SignupResponseModel({
    this.statusCode,
    this.responseCode,
    this.message,
    this.data,
    this.error,
  });

  SignupResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    responseCode = json['responseCode'];
    message = json['message'];
    data = json['data'] != null ? SignedUserData.fromJson(json['data']) : null;
    error = json['error'];
  }
  int? statusCode;
  String? responseCode;
  String? message;
  SignedUserData? data;
  List<Error>? error;
}

class SignedUserData {
  SignedUserData({
    this.profilePic,
    this.status,
    this.otp,
    this.isVerified,
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.company,
    this.positions,
    this.aboutMe,
    this.termsAndConditions,
    this.updatedAt,
    this.createdAt,
  });

  SignedUserData.fromJson(Map<String, dynamic> json) {
    profilePic = json['profile_pic'];
    status = json['status'];
    otp = json['OTP'];
    isVerified = json['isVerified'];
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    company = json['company'];
    positions = json['positions'];
    aboutMe = json['aboutMe'];
    termsAndConditions = json['termsAndConditions'];
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
  }
  String? profilePic;
  String? status;
  int? otp;
  bool? isVerified;
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? company;
  String? positions;
  String? aboutMe;
  bool? termsAndConditions;
  DateTime? updatedAt;
  DateTime? createdAt;
}

class Error {

  Error({this.field, this.message});

  Error.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    message = json['message'];
  }
  String? field;
  String? message;
}