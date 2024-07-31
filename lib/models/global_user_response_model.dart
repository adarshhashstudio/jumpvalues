class GlobalUserResponseModel {
  GlobalUserResponseModel({this.status, this.flag, this.data});

  factory GlobalUserResponseModel.fromJson(Map<String, dynamic> json) =>
      GlobalUserResponseModel(
        status: json['status'],
        flag: json['flag'],
        data: json['data'] != null ? Data.fromJson(json['data']) : null,
      );
  final bool? status;
  final String? flag;
  final Data? data;
}

class Data {
  Data({
    this.id,
    this.referenceId,
    this.firstName,
    this.lastName,
    this.email,
    this.countryCode,
    this.phone,
    this.status,
    this.verified,
    this.otp,
    this.dp,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.roles,
    this.categories,
    this.clientProfile,
    this.coachProfile,
    this.coreValues,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    var rolesList = json['roles'] as List?;
    var categoriesList = json['categories'] as List?;
    var coreValuesList = json['core_values'] as List?;

    return Data(
      id: json['id'],
      referenceId: json['reference_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      countryCode: json['country_code'],
      phone: json['phone'],
      status: json['status'],
      verified: json['verified'],
      otp: json['otp'],
      dp: json['dp'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      roles: rolesList?.map((e) => Role.fromJson(e)).toList(),
      categories: categoriesList,
      clientProfile: json['client_profile'] != null
          ? ClientProfile.fromJson(json['client_profile'])
          : null,
      coachProfile: json['coach_profile'] != null
          ? CoachProfile.fromJson(json['coach_profile'])
          : null,
      coreValues: (json['core_values'] as List<dynamic>?)
          ?.map((e) => CoreValue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  final int? id;
  final String? referenceId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? countryCode;
  final String? phone;
  final int? status;
  final bool? verified;
  final int? otp;
  final String? dp;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final List<Role>? roles;
  final List<dynamic>? categories;
  final ClientProfile? clientProfile;
  final CoachProfile? coachProfile;
  final List<CoreValue>? coreValues;
}

class Role {
  Role({this.id, this.name, this.slug, this.status, this.createdAt});

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json['id'],
        name: json['name'],
        slug: json['slug'],
        status: json['status'],
        createdAt: json['created_at'],
      );
  final int? id;
  final String? name;
  final String? slug;
  final int? status;
  final String? createdAt;
}

class ClientProfile {
  ClientProfile({
    this.id,
    this.userId,
    this.sponsorId,
    this.position,
    this.aboutMe,
    this.updatedBy,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.sponsor,
  });

  factory ClientProfile.fromJson(Map<String, dynamic> json) => ClientProfile(
        id: json['id'],
        userId: json['user_id'],
        sponsorId: json['sponsor_id'],
        position: json['position'],
        aboutMe: json['about_me'],
        updatedBy: json['updated_by'],
        deletedAt: json['deleted_at'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        sponsor:
            json['sponsor'] != null ? Sponsor.fromJson(json['sponsor']) : null,
      );
  final int? id;
  final int? userId;
  final int? sponsorId;
  final String? position;
  final String? aboutMe;
  final String? updatedBy;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final Sponsor? sponsor;
}

class Sponsor {
  Sponsor({
    this.id,
    this.name,
    this.address,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Sponsor.fromJson(Map<String, dynamic> json) => Sponsor(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        status: json['status'],
        deletedAt: json['deleted_at'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
  final int? id;
  final String? name;
  final String? address;
  final int? status;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
}

class CoachProfile {
  factory CoachProfile.fromJson(Map<String, dynamic> json) => CoachProfile(
        id: json['id'],
        userId: json['user_id'],
        education: json['education'],
        preferVia: json['prefer_via'],
        philosophy: json['philosophy'],
        certifications: json['certifications'],
        industriesServed: json['industries_served'],
        experience: json['experiance'],
        niche: json['niche'],
        updatedBy: json['update_by'],
        deletedAt: json['deleted_at'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  CoachProfile({
    this.id,
    this.userId,
    this.education,
    this.preferVia,
    this.philosophy,
    this.certifications,
    this.industriesServed,
    this.experience,
    this.niche,
    this.updatedBy,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });
  final int? id;
  final int? userId;
  final String? education;
  final int? preferVia;
  final String? philosophy;
  final String? certifications;
  final String? industriesServed;
  final int? experience;
  final String? niche;
  final String? updatedBy;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
}

class CoreValue {
  CoreValue({
    this.id,
    this.name,
    this.status,
    this.deletedAt,
    this.createdAt,
  });

  factory CoreValue.fromJson(Map<String, dynamic> json) => CoreValue(
        id: json['id'] as int?,
        name: json['name'] as String?,
        status: json['status'] as int?,
        deletedAt: json['deleted_at'] as String?,
        createdAt: json['created_at'] as String?,
      );
  final int? id;
  final String? name;
  final int? status;
  final String? deletedAt;
  final String? createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'deleted_at': deletedAt,
        'created_at': createdAt,
      };
}
