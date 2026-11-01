import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/pos_widgets.dart';
import 'cashier_screen.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tealDark,
      body: SafeArea(
        child: Column(
          children: [
            PosHeader(
              title: 'Pindai barcode',
              subtitle: 'Tambahkan produk ke keranjang',
              showBack: true,
              action: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.flashlight_on, size: 16),
                label: const Text('Lampu'),
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white30)),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text('Simulasi pratinjau kamera',
                      style: TextStyle(color: Colors.white70, fontSize: 11)),
                  const SizedBox(height: 26),
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .05),
                      border: Border.all(color: Colors.white12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Center(
                      child: Container(
                        width: 220,
                        height: 122,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.tealAccent, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(Icons.view_week,
                              color: Colors.white, size: 160),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  const Center(
                    child: Text('Jaga kamera tetap stabil',
                        style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: AppColors.tealSoft,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('◉  Barcode terbaca',
                            style: TextStyle(
                                color: AppColors.teal,
                                fontWeight: FontWeight.w700)),
                        SizedBox(height: 8),
                        Text('Aqua 600 ml · Rp4.000',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        SizedBox(height: 6),
                        Text('SKU 899200 · 1 unit ditambahkan. Kembali ke Kasir '
                            'untuk meninjau keranjang.',
                            style: TextStyle(
                                color: AppColors.muted, fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  PrimaryButton(
                    label: 'Kembali ke Kasir',
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const CashierScreen()),
                      (route) => false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
