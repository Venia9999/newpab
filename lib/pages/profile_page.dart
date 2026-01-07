import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_info_page.dart';
import 'settings_page.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  const ProfilePage({super.key, required this.userName});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ================= THEME =================
  static const Color gold = Color(0xFFD4AF37);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF555555);

  String name = "";
  File? profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ================= LOAD PROFILE =================
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('name') ?? widget.userName;

      final imagePath = prefs.getString('profile_image');
      if (imagePath != null && imagePath.isNotEmpty) {
        profileImage = File(imagePath);
      }
    });
  }

  // ================= OPEN EDIT PROFILE =================
  Future<void> _openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileInfoPage(userName: name),
      ),
    );

    if (result == true) {
      _loadProfile(); // 🔥 refresh data setelah edit
    }
  }

  // ================= LOGOUT =================
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    // 🔥 hapus semua data login & profil
    await prefs.clear();

    if (!mounted) return;

    // 🔁 pindah ke LoginPage & hapus semua route
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Akun Saya",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: gold,
          ),
        ),
        iconTheme: const IconThemeData(color: gold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
        child: Column(
          children: [
            // ================= AVATAR =================
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [gold, Color(0xFFE6C567)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: gold.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 56,
                backgroundColor: Colors.white,
                backgroundImage: profileImage != null
                    ? FileImage(profileImage!)
                    : const AssetImage(
                        "assets/avatar/default_avatar.png",
                      ) as ImageProvider,
              ),
            ),

            const SizedBox(height: 20),

            // ================= NAMA =================
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Selamat datang di akun kamu 👋",
              style: TextStyle(
                fontSize: 15,
                color: textSecondary,
              ),
            ),

            const SizedBox(height: 36),

            // ================= MENU =================
            _menuCard(
              icon: Icons.person,
              title: "Informasi Profil",
              subtitle: "Lihat dan kelola data akun",
              onTap: _openEditProfile,
            ),

            const SizedBox(height: 16),

            _menuCard(
              icon: Icons.settings,
              title: "Pengaturan",
              subtitle: "Preferensi aplikasi",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 44),

            // ================= LOGOUT =================
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: Colors.black,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= MENU CARD =================
  static Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Card(
          elevation: 4,
          shadowColor: gold.withOpacity(0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: gold),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(
                color: textSecondary,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
