import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final namaCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool loading = false;

  /// 👁️ toggle password
  bool _showPassword = false;

  static const Color gold = Color(0xFFD4AF37);
  static const Color bg = Colors.white;
  static const Color textSecondary = Color(0xFF777777);

  void register() async {
    setState(() => loading = true);

    final res = await ApiService.register(
      namaCtrl.text,
      emailCtrl.text,
      passCtrl.text,
    );

    setState(() => loading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: gold,
        content: Text(
          res['message'] ?? 'Registrasi selesai',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

    if (res['success']) {
      Navigator.pop(context);
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
                "Buat Akun Baru",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: gold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Daftar untuk mulai pesan tiket bioskop",
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
                      controller: namaCtrl,
                      label: "Nama Lengkap",
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _inputField(
                      controller: emailCtrl,
                      label: "Email",
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),

                    /// 🔐 ada icon mata
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
                        onPressed: loading ? null : register,
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
                                "Register",
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
