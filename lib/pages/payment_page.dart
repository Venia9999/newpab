import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/ticket_data.dart';
import '../providers/ticket_provider.dart';
import '../services/notification_service.dart';
import '../models/notification_data.dart';
import 'history_page.dart';

class PaymentPage extends StatefulWidget {
  final TicketData ticket;

  const PaymentPage({
    super.key,
    required this.ticket,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  static const Color gold = Color(0xFFD4AF37);
  File? buktiPembayaran;
  final ImagePicker _picker = ImagePicker();

  String? selectedBank;
  String? virtualAccount;

  // Dummy VA per bank
  final Map<String, String> bankVA = {
    "BCA": "1234567890",
    "BNI": "9876543210",
    "BRI": "1122334455",
    "Mandiri": "5566778899",
  };

  Future<void> _pickImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        buktiPembayaran = File(image.path);
      });
    }
  }

  void _onBankSelected(String? bank) {
    setState(() {
      selectedBank = bank;
      virtualAccount = bank != null ? bankVA[bank] : null;
    });
  }

  void _submitPayment() {
    if (selectedBank == null && buktiPembayaran == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih bank atau upload bukti pembayaran")),
      );
      return;
    }

    Provider.of<TicketProvider>(context, listen: false)
        .addTicket(widget.ticket);

    NotificationService.addNotification(
      NotificationData(
        title: "Pembayaran Berhasil 💳",
        message:
            "Tiket ${widget.ticket.movieTitle} berhasil dibayar ${selectedBank != null ? 'via $selectedBank (VA: $virtualAccount)' : 'dengan bukti pembayaran'}",
        time: DateTime.now(),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HistoryPage(ticket: widget.ticket),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text("Pembayaran Tiket"),
        backgroundColor: Colors.white,
        foregroundColor: gold,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ticketInfoCard(),
            const SizedBox(height: 20),
            _bankSelectionCard(),
            const SizedBox(height: 20),
            _uploadBuktiCard(),
            const SizedBox(height: 30),
            _btnBayar(),
          ],
        ),
      ),
    );
  }

  Widget _ticketInfoCard() {
    final t = widget.ticket;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.movieTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _infoRow("Jam Tayang", t.jam),
          _infoRow("Kursi", t.kursi),
          const Divider(height: 24),
          _infoRow("Total Bayar", "Rp ${t.totalHarga}", highlight: true),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(
            value,
            style: TextStyle(
              fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
              color: highlight ? gold : Colors.black87,
              fontSize: highlight ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bankSelectionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gold, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pilih Bank Virtual Account",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          DropdownButton<String>(
            isExpanded: true,
            hint: const Text("Pilih Bank"),
            value: selectedBank,
            items: bankVA.keys
                .map((bank) => DropdownMenuItem(
                      value: bank,
                      child: Text(bank),
                    ))
                .toList(),
            onChanged: _onBankSelected,
          ),
          if (virtualAccount != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                "Virtual Account: $virtualAccount",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _uploadBuktiCard() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: gold, width: 1.2),
          color: Colors.white,
        ),
        child: buktiPembayaran == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.cloud_upload_outlined, size: 48, color: gold),
                  SizedBox(height: 12),
                  Text(
                    "Upload Bukti Pembayaran",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Tap untuk memilih foto",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(
                  buktiPembayaran!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }

  Widget _btnBayar() {
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
          elevation: 3,
        ),
        onPressed: _submitPayment,
        child: const Text(
          "Bayar Sekarang",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  BoxDecoration _cardStyle() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}
