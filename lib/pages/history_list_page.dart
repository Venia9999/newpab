import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ticket_provider.dart';
import 'history_page.dart';

class HistoryListPage extends StatelessWidget {
  const HistoryListPage({super.key});

  static const Color gold = Color(0xFFD4AF37);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);

  @override
  Widget build(BuildContext context) {
    final tickets = Provider.of<TicketProvider>(context).tickets;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: gold,
        elevation: 0,
        title: const Text(
          "Riwayat Pemesanan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: tickets.isEmpty
          ? _emptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tickets.length,
              itemBuilder: (_, i) {
                final t = tickets[i];
                return _ticketCard(context, t);
              },
            ),
    );
  }

  /// ================= EMPTY STATE =================
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.confirmation_number_outlined,
              size: 64, color: gold),
          SizedBox(height: 12),
          Text(
            "Belum ada pemesanan",
            style: TextStyle(
              fontSize: 16,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= TICKET CARD =================
  Widget _ticketCard(BuildContext context, dynamic t) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HistoryPage(ticket: t),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: gold.withOpacity(0.18),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Film title
            Text(
              t.movieTitle,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            _tableRow("Jam Tayang", t.jam),
            _tableRow("Kursi", t.kursi),
            _tableRow("Jumlah Tiket", "${t.jumlahTiket}"),

            const Divider(height: 22),

            _tableRow(
              "Total Harga",
              "Rp ${t.totalHarga}",
              highlight: true,
            ),
          ],
        ),
      ),
    );
  }

  /// ================= TABLE ROW =================
  Widget _tableRow(
    String label,
    String value, {
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
              color: highlight ? gold : textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
