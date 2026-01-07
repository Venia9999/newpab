import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // ================= THEME =================
  static const Color gold = Color(0xFFD4AF37);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF555555);

  bool notifOn = true;
  bool darkMode = false;
  String videoQuality = "Otomatis";

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // ================= LOAD SETTINGS =================
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notifOn = prefs.getBool('notif_on') ?? true;
      darkMode = prefs.getBool('dark_mode') ?? false;
      videoQuality = prefs.getString('video_quality') ?? "Otomatis";
    });
  }

  // ================= SAVE SETTINGS =================
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_on', notifOn);
    await prefs.setBool('dark_mode', darkMode);
    await prefs.setString('video_quality', videoQuality);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: gold),
        title: const Text(
          "Pengaturan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: gold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        children: [
          _sectionTitle("Preferensi"),

          _switchTile(
            icon: Icons.notifications,
            title: "Notifikasi",
            subtitle: "Aktifkan notifikasi promo",
            value: notifOn,
            onChanged: (val) {
              setState(() => notifOn = val);
              _saveSettings();
            },
          ),

          _switchTile(
            icon: Icons.dark_mode,
            title: "Mode Gelap",
            subtitle: "Tampilan gelap aplikasi",
            value: darkMode,
            onChanged: (val) {
              setState(() => darkMode = val);
              _saveSettings();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Mode gelap global belum diaktifkan"),
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          _sectionTitle("Umum"),

          _menuTile(
            icon: Icons.language,
            title: "Bahasa",
            subtitle: "Bahasa Indonesia",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Fitur pengaturan bahasa belum tersedia"),
                ),
              );
            },
          ),

          _menuTile(
            icon: Icons.high_quality,
            title: "Kualitas Video",
            subtitle: videoQuality,
            onTap: () async {
              final result = await showModalBottomSheet<String>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => _videoQualitySheet(),
              );

              if (result != null) {
                setState(() => videoQuality = result);
                _saveSettings();
              }
            },
          ),

          _menuTile(
            icon: Icons.cleaning_services,
            title: "Bersihkan Cache",
            subtitle: "Hapus data sementara aplikasi",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Cache berhasil dibersihkan"),
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          _sectionTitle("Tentang"),

          _menuTile(
            icon: Icons.info_outline,
            title: "Tentang Aplikasi",
            subtitle: "Informasi aplikasi",
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Bioskop App",
                applicationVersion: "Versi 1.0.0",
                applicationIcon: const Icon(Icons.local_movies),
                children: const [
                  Text(
                    "Aplikasi pemesanan tiket bioskop berbasis Flutter.",
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 40),

          Center(
            child: Text(
              "Versi Aplikasi 1.0.0",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= VIDEO QUALITY SHEET =================
  Widget _videoQualitySheet() {
    final qualities = ["Otomatis", "480p", "720p", "1080p"];

    return ListView(
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      children: qualities.map((q) {
        return ListTile(
          title: Text(q),
          trailing: q == videoQuality
              ? const Icon(Icons.check, color: gold)
              : null,
          onTap: () => Navigator.pop(context, q),
        );
      }).toList(),
    );
  }

  // ================= SECTION TITLE =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: textPrimary,
        ),
      ),
    );
  }

  // ================= SWITCH TILE =================
  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 4,
      shadowColor: gold.withOpacity(0.25),
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: gold,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: textSecondary),
        ),
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: gold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: gold),
        ),
      ),
    );
  }

  // ================= MENU TILE =================
  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shadowColor: gold.withOpacity(0.25),
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
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
          style: const TextStyle(color: textSecondary),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.black54,
        ),
      ),
    );
  }
}
