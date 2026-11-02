import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/pos_widgets.dart';
import '../widgets/qr_code.dart';
import 'receipt_screen.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PosHeader(
              title: 'Bayar dengan QRIS',
              subtitle: 'Langkah 3 dari 4',
              showBack: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warningSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Menunggu pembayaran',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Rp82.000',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Order INV-20261101-0042',
                      style: TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(child: PaymentQrCode()),
                  ),
                  const SizedBox(height: 14),
                  const Center(
                    child: Text(
                      'Kedaluwarsa dalam 14:32',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Scan QR dengan aplikasi pembayaran pelanggan',
                      style: TextStyle(color: AppColors.muted, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReceiptScreen()),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                    ),
                    child: const Text('Simulasikan pembayaran berhasil'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batalkan transaksi'),
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
