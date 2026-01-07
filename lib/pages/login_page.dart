import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../services/api_service.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import 'register_page.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  // ================= THEME =================
  static const Color gold = Color(0xFFD4AF37);
  static const Color bg = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF777777);

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  // ================= LOGIN =================
  void login() async {
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password wajib diisi")),
      );
      return;
    }

    setState(() => loading = true);

    final res = await ApiService.login(
      emailCtrl.text.trim(),
      passCtrl.text.trim(),
    );

    if (!mounted) return;

    setState(() => loading = false);

    if (res['success'] == true) {
      // 🔥 AMBIL DATA USER DARI API
      final userData = res['user'];
      final user = User(
        name: userData['nama'] ?? 'User',
        email: userData['email'] ?? emailCtrl.text.trim(),
      );

      // 🔥 SIMPAN USER KE PROVIDER (INI KUNCI UTAMA)
      Provider.of<UserProvider>(context, listen: false).setUser(user);

      showSimpleNotification(
        Text(
          "Login berhasil! Selamat datang, ${user.name}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: gold,
        leading: const Icon(Icons.check_circle, color: Colors.white),
        autoDismiss: true,
        duration: const Duration(seconds: 3),
      );

      // 🔥 MASUK KE MAIN PAGE
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainPage(userName: user.name),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? 'Login gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              // ================= ICON =================
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: gold.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_movies_outlined,
                  size: 48,
                  color: gold,
                ),
              ),

              const SizedBox(height: 20),

              // ================= TITLE =================
              const Text(
                "Selamat Datang",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: gold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Login untuk melanjutkan ke pemesanan tiket",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),

              const SizedBox(height: 40),

              // ================= FORM CARD =================
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: gold.withOpacity(0.18),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _inputField(
                      controller: emailCtrl,
                      label: "Email",
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),
                    _inputField(
                      controller: passCtrl,
                      label: "Password",
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),
                    const SizedBox(height: 28),

                    // ================= LOGIN BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: loading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gold,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: loading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================= REGISTER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Belum punya akun?",
                    style: TextStyle(color: textSecondary),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= INPUT FIELD =================
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: textSecondary),
        prefixIcon: Icon(icon, color: gold),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: gold.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: gold, width: 1.5),
        ),
      ),
    );
  }
}
