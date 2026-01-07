import 'package:flutter/material.dart';
import '../models/ticket_data.dart';

class TicketProvider extends ChangeNotifier {
  final List<TicketData> _tickets = [];

  List<TicketData> get tickets => List.unmodifiable(_tickets);

  void addTicket(TicketData ticket) {
    _tickets.add(ticket);
    notifyListeners();
  }
}
