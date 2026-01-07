import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileInfoPage extends StatefulWidget {
  final String userName;

  const ProfileInfoPage({super.key, required this.userName});

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  // ================= THEME =================
  static const Color gold = Color(0xFFD4AF37);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF555555);

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // ================= LOAD DATA =================
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      nameController.text =
          prefs.getString('name') ?? widget.userName;
      emailController.text =
          prefs.getString('email') ?? 'user@email.com';
      phoneController.text =
          prefs.getString('phone') ?? '08xxxxxxxxxx';

      final imagePath = prefs.getString('profile_image');
      if (imagePath != null) {
        _profileImage = File(imagePath);
      }
    });
  }

  // ================= SAVE DATA =================
  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', nameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('phone', phoneController.text);

    if (_profileImage != null) {
      await prefs.setString(
          'profile_image', _profileImage!.path);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profil berhasil disimpan"),
        backgroundColor: Colors.black87,
      ),
    );

    Navigator.pop(context, true);
  }

  // ================= PICK IMAGE =================
  Future<void> _pickImage() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
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
          "Edit Profil",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: gold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
        child: Column(
          children: [
            // ================= AVATAR =================
            Stack(
              alignment: Alignment.bottomRight,
              children: [
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
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage(
                                "assets/avatar/default_avatar.png")
                            as ImageProvider,
                  ),
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: gold,
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            _inputField(
              label: "Nama Lengkap",
              controller: nameController,
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            _inputField(
              label: "Email",
              controller: emailController,
              icon: Icons.email,
            ),
            const SizedBox(height: 16),
            _inputField(
              label: "No. Telepon",
              controller: phoneController,
              icon: Icons.phone,
            ),

            const SizedBox(height: 40),

            // ================= SAVE =================
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: Colors.black,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= INPUT =================
  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: textSecondary),
        prefixIcon: Icon(icon, color: gold),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
