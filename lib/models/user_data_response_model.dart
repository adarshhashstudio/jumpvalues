class UserDataResponseModel {
  int? statusCode;
  String? responseCode;
  String? message;
  UserData? data;

  UserDataResponseModel({this.statusCode, this.responseCode, this.message, this.data});

  UserDataResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    responseCode = json['responseCode'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }
}

class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? company;
  String? profilePic;
  String? positions;
  String? aboutMe;
  bool? termsAndConditions;
  String? status;
  String? otp;
  String? createdAt;
  String? updatedAt;
  List<UserRole>? roles;
  List<ComprensiveListing>? comprensiveListings;

  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.company,
    this.profilePic,
    this.positions,
    this.aboutMe,
    this.termsAndConditions,
    this.status,
    this.otp,
    this.createdAt,
    this.updatedAt,
    this.roles,
    this.comprensiveListings,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    company = json['company'];
    profilePic = json['profile_pic'];
    positions = json['positions'];
    aboutMe = json['aboutMe'];
    termsAndConditions = json['termsAndConditions'];
    status = json['status'];
    otp = json['OTP'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['roles'] != null) {
      roles = <UserRole>[];
      json['roles'].forEach((v) {
        roles!.add(UserRole.fromJson(v));
      });
    }
    if (json['comprensive_listings'] != null) {
      comprensiveListings = <ComprensiveListing>[];
      json['comprensive_listings'].forEach((v) {
        comprensiveListings!.add(ComprensiveListing.fromJson(v));
      });
    }
  }
}

class UserRole {
  int? id;
  String? name;
  String? description;
  String? createdAt;
  String? updatedAt;

  UserRole({this.id, this.name, this.description, this.createdAt, this.updatedAt});

  UserRole.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}

class ComprensiveListing {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  ComprensiveListing({this.id, this.name, this.createdAt, this.updatedAt});

  ComprensiveListing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
