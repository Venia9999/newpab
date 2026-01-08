import 'package:flutter/material.dart';
import '../login_page.dart';
import 'add_film_page.dart';
import 'edit_film_page.dart';
import 'delete_film_page.dart';

class AdminFilmPage extends StatelessWidget {
  const AdminFilmPage({super.key});

  static const Color gold = Color(0xFFD4AF37);
  static const Color textSecondary = Color(0xFF777777);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= APP BAR =================
      appBar: AppBar(
        title: const Text(
          "Kelola Film",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: gold,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Logout",
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),

      // ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: gold.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.local_movies_outlined, color: gold, size: 36),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Panel Admin Bioskop",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: gold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Manajemen Film",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            _menuCard(
              context,
              icon: Icons.add_circle_outline,
              title: "Tambah Film",
              subtitle: "Masukkan film baru ke sistem",
              page: const AddFilmPage(),
            ),

            _menuCard(
              context,
              icon: Icons.edit_outlined,
              title: "Edit Film",
              subtitle: "Ubah data film yang tersedia",
              page: const EditFilmPage(),
            ),

            _menuCard(
              context,
              icon: Icons.delete_outline,
              title: "Hapus Film",
              subtitle: "Hapus film dari daftar",
              page: const DeleteFilmPage(),
            ),
          ],
        ),
      ),
    );
  }

  // ================= MENU CARD =================
  Widget _menuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: gold.withOpacity(0.15),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: gold.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: gold),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: gold),
          ],
        ),
      ),
    );
  }
}
