class TimeSlotsListResponseModel {
  TimeSlotsListResponseModel({this.status, this.flag, this.message, this.data});

  factory TimeSlotsListResponseModel.fromJson(Map<String, dynamic> json) =>
      TimeSlotsListResponseModel(
        status: json['status'] as bool?,
        flag: json['flag'] as String?,
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => TimeSlotListItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
  bool? status;
  String? flag;
  String? message;
  List<TimeSlotListItem>? data;

  Map<String, dynamic> toJson() => {
        'status': status,
        'flag': flag,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}

class TimeSlotListItem {
  TimeSlotListItem({this.id, this.start, this.end, this.title, this.status});

  factory TimeSlotListItem.fromJson(Map<String, dynamic> json) =>
      TimeSlotListItem(
        id: json['id'] as int?,
        start: json['start'] as String?,
        end: json['end'] as String?,
        title: json['title'] as String?,
        status: json['status'] as int?,
      );
  int? id;
  String? start;
  String? end;
  String? title;
  int? status;

  Map<String, dynamic> toJson() => {
        'id': id,
        'start': start,
        'end': end,
        'title': title,
        'status': status,
      };
}
