class ConsentQuestionResponse {
  ConsentQuestionResponse({this.status, this.flag, this.message, this.data});

  // fromJson method
  factory ConsentQuestionResponse.fromJson(Map<String, dynamic> json) =>
      ConsentQuestionResponse(
        status: json['status'] as bool?,
        flag: json['flag'] as String?,
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((item) => Question.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
  bool? status;
  String? flag;
  String? message;
  List<Question>? data;

  // toJson method
  Map<String, dynamic> toJson() => {
        'status': status,
        'flag': flag,
        'message': message,
        'data': data?.map((item) => item.toJson()).toList(),
      };
}

class Question {
  Question({
    this.id,
    this.question,
    this.options,
    this.type,
    this.dependentQId,
    this.dependencyValue,
    this.isFollowUpRequired,
    this.createdAt,
    this.updatedAt,
    this.followUpQuestions,
  });

  // fromJson method
  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'] as int?,
        question: json['question'] as String?,
        options: (json['options'] as List<dynamic>?)
            ?.map((item) => Option.fromJson(item as Map<String, dynamic>))
            .toList(),
        type: json['type'] as int?,
        dependentQId: json['dependent_q_id'] as int?,
        dependencyValue: json['dependency_value'] as String?,
        isFollowUpRequired: json['is_follow_up_required'] as bool?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        followUpQuestions: (json['followUpQuestions'] as List<dynamic>?)
            ?.map((item) => Question.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
  int? id;
  String? question;
  List<Option>? options;
  int? type;
  int? dependentQId;
  String? dependencyValue;
  bool? isFollowUpRequired;
  String? createdAt;
  String? updatedAt;
  List<Question>? followUpQuestions;

  // toJson method
  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'options': options?.map((item) => item.toJson()).toList(),
        'type': type,
        'dependent_q_id': dependentQId,
        'dependency_value': dependencyValue,
        'is_follow_up_required': isFollowUpRequired,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'followUpQuestions':
            followUpQuestions?.map((item) => item.toJson()).toList(),
      };
}

class Option {
  Option({this.id, this.value});

  // fromJson method
  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json['id'] as int?,
        value: json['value'] as String?,
      );
  int? id;
  String? value;

  // toJson method
  Map<String, dynamic> toJson() => {
        'id': id,
        'value': value,
      };
}
