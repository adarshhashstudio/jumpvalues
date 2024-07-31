class CoachProfileResponseModel {
  CoachProfileResponseModel({
    this.status,
    this.flag,
    this.message,
    this.data,
  });

  factory CoachProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      CoachProfileResponseModel(
        status: json['status'] as bool?,
        flag: json['flag'] as String?,
        message: json['message'] as String?,
        data: json['data'] != null
            ? CoachData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );
  final bool? status;
  final String? flag;
  final String? message;
  final CoachData? data;

  Map<String, dynamic> toJson() => {
        'status': status,
        'flag': flag,
        'message': message,
        'data': data?.toJson(),
      };
}

class CoachData {
  CoachData({
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
    this.categories,
    this.coachProfile,
    this.coreValues,
  });

  factory CoachData.fromJson(Map<String, dynamic> json) => CoachData(
        id: json['id'] as int?,
        referenceId: json['reference_id'] as String?,
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        email: json['email'] as String?,
        countryCode: json['country_code'] as String?,
        phone: json['phone'] as String?,
        status: json['status'] as int?,
        verified: json['verified'] as bool?,
        otp: json['otp'] as int?,
        dp: json['dp'] as String?,
        createdBy: json['created_by'] as String?,
        updatedBy: json['updated_by'] as String?,
        deletedAt: json['deleted_at'] as String?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        categories: (json['categories'] as List<dynamic>?)
            ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList(),
        coachProfile: json['coach_profile'] != null
            ? CoachProfile.fromJson(
                json['coach_profile'] as Map<String, dynamic>)
            : null,
        coreValues: json['core_values'] as List<dynamic>?,
      );
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
  final List<Category>? categories;
  final CoachProfile? coachProfile;
  final List<dynamic>? coreValues;

  Map<String, dynamic> toJson() => {
        'id': id,
        'reference_id': referenceId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'country_code': countryCode,
        'phone': phone,
        'status': status,
        'verified': verified,
        'otp': otp,
        'dp': dp,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'categories': categories?.map((e) => e.toJson()).toList(),
        'coach_profile': coachProfile?.toJson(),
        'core_values': coreValues,
      };
}

class Category {
  Category({
    this.id,
    this.name,
    this.status,
    this.deletedAt,
    this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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

class CoachProfile {
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
    this.updateBy,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory CoachProfile.fromJson(Map<String, dynamic> json) => CoachProfile(
        id: json['id'] as int?,
        userId: json['user_id'] as int?,
        education: json['education'] as String?,
        preferVia: json['prefer_via'] as int?,
        philosophy: json['philosophy'] as String?,
        certifications: json['certifications'] as String?,
        industriesServed: json['industries_served'] as String?,
        experience: json['experiance'] as int?,
        niche: json['niche'] as String?,
        updateBy: json['update_by'] as String?,
        deletedAt: json['deleted_at'] as String?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
      );
  final int? id;
  final int? userId;
  final String? education;
  final int? preferVia;
  final String? philosophy;
  final String? certifications;
  final String? industriesServed;
  final int? experience;
  final String? niche;
  final String? updateBy;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'education': education,
        'prefer_via': preferVia,
        'philosophy': philosophy,
        'certifications': certifications,
        'industries_served': industriesServed,
        'experiance': experience,
        'niche': niche,
        'update_by': updateBy,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
