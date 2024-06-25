class BookingItem {
  BookingItem({
    this.status,
    this.imageUrl,
    this.bookingId,
    this.serviceName,
    this.date,
    this.time,
    this.customerName,
    this.description,
  });

  factory BookingItem.fromJson(Map<String, dynamic> json) => BookingItem(
        status: json['status'] as String?,
        imageUrl: json['imageUrl'] as String?,
        bookingId: json['bookingId'] as String?,
        serviceName: json['serviceName'] as String?,
        date: json['date'] as String?,
        time: json['time'] as String?,
        customerName: json['customerName'] as String?,
        description: json['description'] as String?,
      );

  final String? status;
  final String? imageUrl;
  final String? bookingId;
  final String? serviceName;
  final String? date;
  final String? time;
  final String? customerName;
  final String? description;
}
