import 'package:flutter/material.dart';

import '../screens/cashier_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/pos_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(text: 'rina.kasir');
  final _passwordController = TextEditingController(text: '12345678');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 30, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('SmartPOS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const Text('Toko Maju Jaya',
                  style: TextStyle(color: AppColors.muted, fontSize: 10)),
              const SizedBox(height: 54),
              Container(
                width: 47,
                height: 47,
                decoration: BoxDecoration(
                    color: AppColors.teal,
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.qr_code_scanner,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(height: 18),
              const Text('Siap melayani, Rina?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              const Text('Masuk dengan akun kasir untuk memulai transaksi\n'
                  'di Toko Maju Jaya.',
                  style: TextStyle(color: AppColors.muted, height: 1.5)),
              const SizedBox(height: 26),
              const Text('Akun', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 7),
              TextField(controller: _usernameController),
              const SizedBox(height: 15),
              const Text('Kata sandi',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 7),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Login',
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const CashierScreen()),
                ),
              ),
              const SizedBox(height: 32),
              const Center(
                child: Text('Kesulitan masuk? Hubungi admin toko. Akun kasir\n'
                    'dibuat oleh admin.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.muted, fontSize: 11)),
              ),
              const SizedBox(height: 74),
              const Center(
                child: Text('◈ Aplikasi memerlukan koneksi internet\n'
                    'SmartPOS · Versi 1.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.muted, fontSize: 10)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
