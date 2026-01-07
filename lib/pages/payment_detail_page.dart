import 'package:flutter/material.dart';
import '../models/ticket_data.dart';

class PaymentDetailPage extends StatelessWidget {
  final TicketData ticket;
  const PaymentDetailPage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pembayaran"),
        backgroundColor: const Color(0xFF0A1F44),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _item("Film", ticket.movieTitle),
            _item("Jam", ticket.jam),
            _item("Kursi", ticket.kursi),
            _item("Jumlah", ticket.jumlahTiket.toString()),
            _item("Metode", ticket.metodePembayaran),
            _item("VA", ticket.virtualAccount),
            const Divider(height: 30),
            _item("Total", "Rp ${ticket.totalHarga}",
                bold: true),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A1F44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Kembali"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _item(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value,
              style: TextStyle(
                  fontWeight:
                      bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
