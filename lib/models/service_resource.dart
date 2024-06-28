class ServiceResource {
  ServiceResource(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.avatar,
      this.status});

  factory ServiceResource.fromJson(Map<String, dynamic> json) =>
      ServiceResource(
        id: json['id'],
        email: json['email'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        avatar: json['avatar'],
        status: json['status'],
      );
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? avatar;
  String? status = 'All';

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'avatar': avatar,
      };
}

class ServiceResourcePagination {
  ServiceResourcePagination({
    this.page,
    this.perPage,
    this.total,
    this.totalPages,
    this.data,
    this.support,
  });

  factory ServiceResourcePagination.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<ServiceResource> resourceList =
        list.map((i) => ServiceResource.fromJson(i)).toList();

    return ServiceResourcePagination(
      page: json['page'],
      perPage: json['per_page'],
      total: json['total'],
      totalPages: json['total_pages'],
      data: resourceList,
      support:
          json['support'] != null ? Support.fromJson(json['support']) : null,
    );
  }
  int? page;
  int? perPage;
  int? total;
  int? totalPages;
  List<ServiceResource>? data;
  Support? support;

  Map<String, dynamic> toJson() => {
        'page': page,
        'per_page': perPage,
        'total': total,
        'total_pages': totalPages,
        'data': data?.map((e) => e.toJson()).toList(),
        'support': support?.toJson(),
      };
}

class Support {
  Support({this.url, this.text});

  factory Support.fromJson(Map<String, dynamic> json) => Support(
        url: json['url'],
        text: json['text'],
      );
  String? url;
  String? text;

  Map<String, dynamic> toJson() => {
        'url': url,
        'text': text,
      };
}
