import 'package:flutter/material.dart';

class DeleteFilmPage extends StatelessWidget {
  const DeleteFilmPage({super.key});

  static const Color gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hapus Film"),
        backgroundColor: Colors.white,
        foregroundColor: gold,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          "LIST FILM UNTUK DIHAPUS",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
