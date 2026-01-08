import 'package:flutter/material.dart';

class EditFilmPage extends StatefulWidget {
  const EditFilmPage({super.key});

  @override
  State<EditFilmPage> createState() => _EditFilmPageState();
}

class _EditFilmPageState extends State<EditFilmPage> {
  final titleCtrl = TextEditingController(text: "Avengers Endgame");
  final genreCtrl = TextEditingController(text: "Action");
  final durationCtrl = TextEditingController(text: "180");
  final descCtrl =
      TextEditingController(text: "Film superhero Marvel.");

  static const Color gold = Color(0xFFD4AF37);

  void update() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Film berhasil diperbarui")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Film"),
        backgroundColor: Colors.white,
        foregroundColor: gold,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _input("Judul Film", titleCtrl),
            _input("Genre", genreCtrl),
            _input("Durasi (menit)", durationCtrl,
                keyboard: TextInputType.number),
            _input("Deskripsi", descCtrl, maxLines: 4),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: update,
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Update Film",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: gold),
          ),
        ),
      ),
    );
  }
}
