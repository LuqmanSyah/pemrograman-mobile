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
              const SizedBox(height: 34),
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Center(child: Text('K', style: TextStyle(
                      color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800))),
                ),
              ),
              const SizedBox(height: 14),
              const Center(child: Text('KASIRKU',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
              const SizedBox(height: 4),
              const Center(child: Text('Masuk untuk mulai berjualan',
                  style: TextStyle(color: AppColors.muted, fontSize: 12))),
              const SizedBox(height: 42),
              const Text('Email / Username', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
              const SizedBox(height: 7),
              TextField(controller: _usernameController),
              const SizedBox(height: 15),
              const Text('Password',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Lupa password?'),
                ),
              ),
              PrimaryButton(
                label: 'Masuk',
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const CashierScreen()),
                ),
              ),
              const Center(
                child: Text('Outlet Sudirman',
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
