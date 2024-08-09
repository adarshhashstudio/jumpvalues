class AvailableCoachesResponseModel {
  AvailableCoachesResponseModel({
    this.status,
    this.flag,
    this.message,
    this.pageDetails,
    this.data,
  });

  factory AvailableCoachesResponseModel.fromJson(Map<String, dynamic> json) =>
      AvailableCoachesResponseModel(
        status: json['status'],
        flag: json['flag'],
        message: json['message'],
        pageDetails: json['page_details'] != null
            ? PageDetails.fromJson(json['page_details'])
            : null,
        data: json['data'] != null
            ? (json['data'] as List)
                .map((item) => AvailableCoaches.fromJson(item))
                .toList()
            : null,
      );
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
        'data': data?.map((item) => item.toJson()).toList(),
      };
}

class PageDetails {
  PageDetails({
    this.page,
    this.limit,
    this.noOfRecords,
  });

  factory PageDetails.fromJson(Map<String, dynamic> json) => PageDetails(
        page: json['page'],
        limit: json['limit'],
        noOfRecords: json['no_of_records'],
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
  factory AvailableCoaches.fromJson(Map<String, dynamic> json) =>
      AvailableCoaches(
        id: json['id'],
        referenceId: json['reference_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        countryCode: json['country_code'],
        phone: json['phone'],
        status: json['status'],
        verified: json['verified'],
        dp: json['dp'],
        experience: json['experiance'],
        niche: json['niche'],
        education: json['education'],
        philosophy: json['philosophy'],
        certifications: json['certifications'],
        industriesServed: json['industries_served'],
        preferVia: json['prefer_via'],
        totalSessions: json['total_sessions'],
        rating: (json['rating'] as num?)?.toDouble(),
      );

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
    this.totalSessions,
    this.rating,
  });
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
  int? totalSessions;
  double? rating;

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
        'dp': dp,
        'experiance': experience,
        'niche': niche,
        'education': education,
        'philosophy': philosophy,
        'certifications': certifications,
        'industries_served': industriesServed,
        'prefer_via': preferVia,
        'total_sessions': totalSessions,
        'rating': rating,
      };
}
