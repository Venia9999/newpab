import 'package:flutter/material.dart';
import '../models/ticket_data.dart';

class HistoryPage extends StatelessWidget {
  final TicketData ticket;

  const HistoryPage({super.key, required this.ticket});

  static const Color gold = Color(0xFFD4AF37);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);

  String get kodePembelian {
    return "BKP-${ticket.tanggal.year}${ticket.tanggal.month}${ticket.tanggal.day}-${ticket.tanggal.millisecondsSinceEpoch.toString().substring(8)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: gold),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Detail Tiket",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: gold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _ticketCard(),
              const SizedBox(height: 24),
              _infoLoket(),
              const Spacer(),
              _btnKembaliHome(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ticketCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: gold.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rowInfo("Film", ticket.movieTitle),
          _divider(),
          _rowInfo("Jam Tayang", ticket.jam),
          _rowInfo("Kursi", ticket.kursi),
          _rowInfo("Jumlah Tiket", "${ticket.jumlahTiket}"),
          _rowInfo(
            "Tanggal",
            "${ticket.tanggal.day}-${ticket.tanggal.month}-${ticket.tanggal.year}",
          ),
          _divider(),
          _rowInfo(
            "Total Harga",
            "Rp ${ticket.totalHarga}",
            isHighlight: true,
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [gold, Color(0xFFE6C567)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Kode Pembelian",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  kodePembelian,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoLoket() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: gold),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Tunjukkan kode pembelian ini ke loket bioskop untuk mencetak tiket.",
              style: TextStyle(
                fontSize: 13,
                color: textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _btnKembaliHome(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.black,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: const Text(
          "Kembali ke Home",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _rowInfo(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: textSecondary,
              fontSize: 14,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
                color: isHighlight ? gold : textPrimary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(color: Colors.grey.shade300),
    );
  }
}
