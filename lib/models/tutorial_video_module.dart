class Videos {
  Videos({this.count, this.rows});

  // From JSON
  factory Videos.fromJson(Map<String, dynamic> json) {
    var rowsList = json['rows'] as List<dynamic>?;
    return Videos(
      count: json['count'] as int?,
      rows: rowsList != null
          ? rowsList.map((item) => VideoRow.fromJson(item)).toList()
          : null,
    );
  }
  int? count;
  List<VideoRow>? rows;

  // To JSON
  Map<String, dynamic> toJson() => {
        'count': count,
        'rows': rows?.map((item) => item.toJson()).toList(),
      };
}

class VideoRow {
  VideoRow({
    this.id,
    this.title,
    this.slug,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  // From JSON
  factory VideoRow.fromJson(Map<String, dynamic> json) => VideoRow(
        id: json['id'] as int?,
        title: json['title'] as String?,
        slug: json['slug'] as String?,
        url: json['URL'] as String?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
      );
  int? id;
  String? title;
  String? slug;
  String? url;
  String? createdAt;
  String? updatedAt;

  // To JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'slug': slug,
        'URL': url,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
