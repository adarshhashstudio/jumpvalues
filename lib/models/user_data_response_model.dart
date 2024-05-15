class UserDataResponseModel {
  UserDataResponseModel(
      {this.statusCode, this.responseCode, this.message, this.data});

  UserDataResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    responseCode = json['responseCode'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }
  int? statusCode;
  String? responseCode;
  String? message;
  UserData? data;
}

class UserData {
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
}

class UserRole {
  UserRole(
      {this.id, this.name, this.description, this.createdAt, this.updatedAt});

  UserRole.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  int? id;
  String? name;
  String? description;
  String? createdAt;
  String? updatedAt;
}

class ComprensiveListing {
  ComprensiveListing({this.id, this.name, this.createdAt, this.updatedAt});

  ComprensiveListing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
}
