class QuestionModel {
  QuestionModel({this.id, this.question, this.options, this.type});

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        id: json['id'] as String?,
        question: json['question'] as String?,
        options: (json['options'] as List?)
            ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
            .toList(),
        type: json['type'] as String?,
      );
  String? id;
  String? question;
  List<Option>? options;
  String? type;

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'options': options?.map((e) => e.toJson()).toList(),
        'type': type,
      };
}

class Option {
  Option({this.id, this.value});

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json['id'] as int?,
        value: json['value'] as String?,
      );
  int? id;
  String? value;

  Map<String, dynamic> toJson() => {
        'id': id,
        'value': value,
      };
}
