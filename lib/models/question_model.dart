class ConsentQuestionResponse {
  ConsentQuestionResponse(
      {this.status, this.flag, this.message, this.pageDetails, this.data});

  factory ConsentQuestionResponse.fromJson(Map<String, dynamic> json) =>
      ConsentQuestionResponse(
        status: json['status'],
        flag: json['flag'],
        message: json['message'],
        pageDetails: json['page_details'] != null
            ? PageDetails.fromJson(json['page_details'])
            : null,
        data: json['data'] != null
            ? List<Question>.from(
                json['data'].map((item) => Question.fromJson(item)))
            : null,
      );
  bool? status;
  String? flag;
  String? message;
  PageDetails? pageDetails;
  List<Question>? data;

  Map<String, dynamic> toJson() => {
        'status': status,
        'flag': flag,
        'message': message,
        'page_details': pageDetails?.toJson(),
        'data':
            data != null ? data!.map((item) => item.toJson()).toList() : null,
      };
}

class PageDetails {
  PageDetails({this.page, this.limit, this.noOfRecords});

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

class Question {
  Question(
      {this.id,
      this.question,
      this.options,
      this.type,
      this.createdAt,
      this.updatedAt});

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'],
        question: json['question'],
        options: json['options'] != null
            ? List<Option>.from(
                json['options'].map((item) => Option.fromJson(item)))
            : null,
        type: json['type'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
  int? id;
  String? question;
  List<Option>? options;
  int? type;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'options': options != null
            ? options!.map((item) => item.toJson()).toList()
            : null,
        'type': type,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class Option {
  Option({this.id, this.value});

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json['id'],
        value: json['value'],
      );
  int? id;
  String? value;

  Map<String, dynamic> toJson() => {
        'id': id,
        'value': value,
      };
}
