class AvailableCoachesResponseModel {
  factory AvailableCoachesResponseModel.fromJson(Map<String, dynamic> json) =>
      AvailableCoachesResponseModel(
        status: json['status'] as bool?,
        flag: json['flag'] as String?,
        message: json['message'] as String?,
        pageDetails: json['page_details'] != null
            ? PageDetails.fromJson(json['page_details'])
            : null,
        data: (json['data'] as List<dynamic>?)
            ?.map((item) =>
                AvailableCoaches.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

  AvailableCoachesResponseModel({
    this.status,
    this.flag,
    this.message,
    this.pageDetails,
    this.data,
  });
  bool? status;
  String? flag;
  String? message;
  PageDetails? pageDetails;
  List<AvailableCoaches>? data;

  Map<String, dynamic> toJson() => {
        'status': status,
        'flag': flag,
        'message': message,
        'page_details': pageDetails?.toJson(),
        'data': data?.map((coach) => coach.toJson()).toList(),
      };
}

class PageDetails {
  PageDetails({this.page, this.limit, this.noOfRecords});

  factory PageDetails.fromJson(Map<String, dynamic> json) => PageDetails(
        page: json['page'] as int?,
        limit: json['limit'] as int?,
        noOfRecords: json['no_of_records'] as int?,
      );
  int? page;
  int? limit;
  int? noOfRecords;

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        'no_of_records': noOfRecords,
      };
}

class AvailableCoaches {
  AvailableCoaches({
    this.id,
    this.referenceId,
    this.firstName,
    this.lastName,
    this.email,
    this.countryCode,
    this.phone,
    this.status,
    this.verified,
    this.dp,
    this.experience,
    this.niche,
    this.education,
    this.philosophy,
    this.certifications,
    this.industriesServed,
    this.preferVia,
  });

  factory AvailableCoaches.fromJson(Map<String, dynamic> json) =>
      AvailableCoaches(
        id: json['id'] as int?,
        referenceId: json['reference_id'] as String?,
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        email: json['email'] as String?,
        countryCode: json['country_code'] as String?,
        phone: json['phone'] as String?,
        status: json['status'] as int?,
        verified: json['verified'] as bool?,
        dp: json['dp'] as String?,
        experience: json['experiance'] as int?,
        niche: json['niche'] as String?,
        education: json['education'] as String?,
        philosophy: json['philosophy'] as String?,
        certifications: json['certifications'] as String?,
        industriesServed: json['industries_served'] as String?,
        preferVia: json['prefer_via'] as int?,
      );
  int? id;
  String? referenceId;
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? phone;
  int? status;
  bool? verified;
  String? dp;
  int? experience;
  String? niche;
  String? education;
  String? philosophy;
  String? certifications;
  String? industriesServed;
  int? preferVia;

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
        'experiance': experience,
        'niche': niche,
        'education': education,
        'philosophy': philosophy,
        'certifications': certifications,
        'industries_served': industriesServed,
        'prefer_via': preferVia,
      };
}
