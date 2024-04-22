class LoginResponseModel {
  final int? responseCode;
  final String? responseStatus;
  final String? message;
  final String? token;
  final UserData? data;

  LoginResponseModel({
    this.responseCode,
    this.responseStatus,
    this.message,
    this.token,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      responseCode: json['responseCode'],
      responseStatus: json['responseStatus'],
      message: json['message'],
      token: json['token'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? company;
  final String? profilePic;
  final String? positions;
  final String? aboutMe;
  final bool? termsAndConditions;
  final String? resetToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Role>? roles;

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
    this.resetToken,
    this.createdAt,
    this.updatedAt,
    this.roles,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      company: json['company'],
      profilePic: json['profile_pic'],
      positions: json['positions'],
      aboutMe: json['aboutMe'],
      termsAndConditions: json['termsAndConditions'],
      resetToken: json['resetToken'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      roles: json['roles'] != null
          ? List<Role>.from(json['roles'].map((x) => Role.fromJson(x)))
          : null,
    );
  }
}

class Role {
  final int? id;
  final String? name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserHasRole? userHasRole;

  Role({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.userHasRole,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      userHasRole: json['user_has_role'] != null ? UserHasRole.fromJson(json['user_has_role']) : null,
    );
  }
}

class UserHasRole {
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? roleId;

  UserHasRole({
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.roleId,
  });

  factory UserHasRole.fromJson(Map<String, dynamic> json) {
    return UserHasRole(
      userId: json['userId'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      roleId: json['RoleId'],
    );
  }
}
