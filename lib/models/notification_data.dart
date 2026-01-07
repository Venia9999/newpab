class NotificationData {
  final String title;
  final String message;
  final DateTime time;

  NotificationData({
    required this.title,
    required this.message,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'message': message,
        'time': time.toIso8601String(),
      };

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: json['title'],
      message: json['message'],
      time: DateTime.parse(json['time']),
    );
  }
}
