import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart'; // ✅ INI YANG KURANG

class AddFilmPage extends StatefulWidget {
  const AddFilmPage({super.key});

  @override
  State<AddFilmPage> createState() => _AddFilmPageState();
}

class _AddFilmPageState extends State<AddFilmPage> {
  static const Color gold = Color(0xFFD4AF37);

  final titleCtrl = TextEditingController();
  final genreCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  File? posterFile;
  final picker = ImagePicker();

  // ================= PICK IMAGE =================
  Future<void> pickPoster() async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() => posterFile = File(picked.path));
    }
  }

  // ================= SAVE =================
  Future<void> saveFilm() async {
    if (posterFile == null ||
        titleCtrl.text.isEmpty ||
        genreCtrl.text.isEmpty ||
        durationCtrl.text.isEmpty ||
        descCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data")),
      );
      return;
    }

    final success = await ApiService.addMovie(
      title: titleCtrl.text,
      genre: genreCtrl.text,
      duration: durationCtrl.text,
      description: descCtrl.text,
      poster: posterFile!,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Film berhasil ditambahkan")),
      );
      Navigator.pop(context, true); // 🔥 refresh admin page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan film")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EF),
      appBar: AppBar(
        title: const Text("Tambah Film"),
        backgroundColor: Colors.white,
        foregroundColor: gold,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickPoster,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: gold),
                  image: posterFile != null
                      ? DecorationImage(
                          image: FileImage(posterFile!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: posterFile == null
                    ? const Center(
                        child: Text(
                          "Upload Poster Film",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: gold,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            _input(titleCtrl, "Judul Film"),
            _input(genreCtrl, "Genre"),
            _input(durationCtrl, "Durasi (menit)",
                keyboard: TextInputType.number),
            _input(descCtrl, "Deskripsi", maxLines: 4),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveFilm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Simpan Film",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
