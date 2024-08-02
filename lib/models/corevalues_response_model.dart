class CoreValue {
  CoreValue({
    this.id,
    this.name,
    this.status,
    this.deletedAt,
    this.createdAt,
  });

  factory CoreValue.fromJson(Map<String, dynamic> json) => CoreValue(
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
