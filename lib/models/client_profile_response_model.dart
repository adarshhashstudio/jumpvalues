import 'package:jumpvalues/models/corevalues_response_model.dart';

class ClientProfileResponseModel {
  factory ClientProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      ClientProfileResponseModel(
        status: json['status'] as bool?,
        flag: json['flag'] as String?,
        message: json['message'] as String?,
        data: json['data'] != null
            ? ClientData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );

  ClientProfileResponseModel({
    this.status,
    this.flag,
    this.message,
    this.data,
  });
  final bool? status;
  final String? flag;
  final String? message;
  final ClientData? data;

  Map<String, dynamic> toJson() => {
        'status': status,
        'flag': flag,
        'message': message,
        'data': data?.toJson(),
      };
}

class ClientData {
  ClientData({
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
    this.additionalSponsor,
    this.sponsorChanged,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.categories,
    this.clientProfile,
    this.coreValues,
  });

  factory ClientData.fromJson(Map<String, dynamic> json) => ClientData(
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
        additionalSponsor: json['additional_sponsor'],
        sponsorChanged: json['sponsor_changed'],
        createdBy: json['created_by'] as int?,
        updatedBy: json['updated_by'] as int?,
        deletedAt: json['deleted_at'] as String?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        categories: (json['categories'] as List<dynamic>?)
            ?.map((e) => CoreValue.fromJson(e as Map<String, dynamic>))
            .toList(),
        clientProfile: json['client_profile'] != null
            ? ClientProfile.fromJson(
                json['client_profile'] as Map<String, dynamic>)
            : null,
        coreValues: (json['core_values'] as List<dynamic>?)
            ?.map((e) => CoreValue.fromJson(e as Map<String, dynamic>))
            .toList(),
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
  final String? additionalSponsor;
  final bool? sponsorChanged;
  final int? createdBy;
  final int? updatedBy;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final ClientProfile? clientProfile;
  final List<CoreValue>? categories;
  final List<CoreValue>? coreValues;

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
        'additional_sponsor': additionalSponsor,
        'sponsor_changed': sponsorChanged,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'categories': categories,
        'client_profile': clientProfile?.toJson(),
        'core_values': coreValues?.map((e) => e.toJson()).toList(),
      };
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
        id: json['id'] as int?,
        userId: json['user_id'] as int?,
        sponsorId: json['sponsor_id'] as int?,
        position: json['position'] as String?,
        aboutMe: json['about_me'] as String?,
        updatedBy: json['updated_by'] as int?,
        deletedAt: json['deleted_at'] as String?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        sponsor: json['sponsor'] != null
            ? Sponsor.fromJson(json['sponsor'] as Map<String, dynamic>)
            : null,
      );
  final int? id;
  final int? userId;
  final int? sponsorId;
  final String? position;
  final String? aboutMe;
  final int? updatedBy;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final Sponsor? sponsor;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'sponsor_id': sponsorId,
        'position': position,
        'about_me': aboutMe,
        'updated_by': updatedBy,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'sponsor': sponsor?.toJson(),
      };
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
        id: json['id'] as int?,
        name: json['name'] as String?,
        address: json['address'] as String?,
        status: json['status'] as int?,
        deletedAt: json['deleted_at'] as String?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
      );
  final int? id;
  final String? name;
  final String? address;
  final int? status;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'status': status,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
