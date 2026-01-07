class Ticket {
  final String bookingCode;
  final String movieTitle;
  final String userName;
  final String showTime;
  final String seat;
  final String status;
  final String orderDate;

  Ticket({
    required this.bookingCode,
    required this.movieTitle,
    required this.userName,
    required this.showTime,
    required this.seat,
    required this.status,
    required this.orderDate,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      bookingCode: json['booking_code'],
      movieTitle: json['title'],
      userName: json['nama'],
      showTime: json['show_time'],
      seat: json['seat'],
      status: json['status'],
      orderDate: json['order_date'],
    );
  }
}
