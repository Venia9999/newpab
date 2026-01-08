import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../services/api_service.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import 'register_page.dart';
import 'main_page.dart';
import '../pages/admin/admin_film_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  /// 👁️ status lihat/sembunyi password
  bool _showPassword = false;

  static const Color gold = Color(0xFFD4AF37);
  static const Color bg = Colors.white;
  static const Color textSecondary = Color(0xFF777777);

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> login() async {
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
      final userData = res['user'];

      final user = User(
        id: userData['id'].toString(),
        name: userData['nama'] ?? 'User',
        email: userData['email'] ?? emailCtrl.text.trim(),
        role: userData['role'] ?? 'user',
      );

      Provider.of<UserProvider>(context, listen: false).setUser(user);

      showSimpleNotification(
        Text(
          "Login sebagai ${user.role.toUpperCase()}",
          style: const TextStyle(color: Colors.white),
        ),
        background: gold,
        leading: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 2),
      );

      if (user.isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminFilmPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainPage(userName: user.name)),
        );
      }
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
            children: [
              const SizedBox(height: 30),

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
                "Login untuk melanjutkan",
                style: TextStyle(color: textSecondary),
              ),

              const SizedBox(height: 40),

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

                    /// 🔐 ada toggle mata
                    _inputField(
                      controller: passCtrl,
                      label: "Password",
                      icon: Icons.lock_outline,
                      obscure: !_showPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: gold,
                        ),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: loading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gold,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun?"),
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

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: gold),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: gold),
        ),
      ),
    );
  }
}
