import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../models/ticket_data.dart';
import '../providers/ticket_provider.dart';
import '../providers/user_provider.dart';
import 'payment_page.dart';

class TicketPage extends StatefulWidget {
  final Movie movie;
  final String selectedJam;

  const TicketPage({
    super.key,
    required this.movie,
    required this.selectedJam,
  });

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  static const Color gold = Color(0xFFD4AF37);
  static const Color bg = Color(0xFFF6F6F6);

  late String jamDipilih;
  List<String> kursiDipilih = [];

  static const int hargaTiket = 40000;

  int get jumlahTiket => kursiDipilih.length;
  int get totalHarga => jumlahTiket * hargaTiket;

  final List<String> kursiAtas = List.generate(10, (i) => "A${i + 1}");
  final List<String> kursiTengah = List.generate(10, (i) => "B${i + 1}");
  final List<String> kursiBawah = List.generate(10, (i) => "C${i + 1}");

  @override
  void initState() {
    super.initState();
    jamDipilih = widget.selectedJam;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Pesan Tiket"),
        backgroundColor: Colors.white,
        foregroundColor: gold,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoFilm(),
            const SizedBox(height: 24),
            _sectionTitle("Pilih Kursi"),
            _kursiSection("ATAS", kursiAtas),
            _kursiSection("TENGAH", kursiTengah),
            _kursiSection("BAWAH", kursiBawah),
            const SizedBox(height: 20),
            _infoHarga(),
            const SizedBox(height: 30),
            _tombolLanjutBayar(),
          ],
        ),
      ),
    );
  }

  Widget _infoFilm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _box(),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              widget.movie.poster,
              width: 90,
              height: 130,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movie.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text("Jam Tayang: $jamDipilih"),
                const SizedBox(height: 6),
                const Text("Harga / tiket: Rp 40.000"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: gold,
        ),
      ),
    );
  }

  Widget _kursiSection(String label, List<String> seats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: seats.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (_, i) {
            final seat = seats[i];
            final selected = kursiDipilih.contains(seat);

            return GestureDetector(
              onTap: () {
                setState(() {
                  selected
                      ? kursiDipilih.remove(seat)
                      : kursiDipilih.add(seat);
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? gold : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: gold),
                ),
                child: Text(
                  seat,
                  style: TextStyle(
                    color: selected ? Colors.white : gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _infoHarga() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _box(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total ($jumlahTiket tiket)"),
          Text(
            "Rp $totalHarga",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: gold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tombolLanjutBayar() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: jumlahTiket == 0
            ? null
            : () {
                final user =
                    Provider.of<UserProvider>(context, listen: false).user;
                if (user == null) return;

                final ticket = TicketData(
                  namaUser: user.name,
                  movieTitle: widget.movie.title,
                  jam: jamDipilih,
                  kursi: kursiDipilih.join(", "),
                  tanggal: DateTime.now(),
                  jumlahTiket: jumlahTiket,
                  totalHarga: totalHarga,
                  metodePembayaran: "BCA", // default
                  virtualAccount: "VA-${DateTime.now().millisecondsSinceEpoch}",
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentPage(ticket: ticket),
                  ),
                );
              },
        child: const Text(
          "Lanjut ke Pembayaran",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  BoxDecoration _box() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
        ),
      ],
    );
  }
}
