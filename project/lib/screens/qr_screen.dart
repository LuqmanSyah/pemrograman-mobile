import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/pos_widgets.dart';
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
              title: 'Pembayaran QRIS',
              subtitle: 'MJ-261101-0042',
              showBack: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Center(
                    child: Text('Toko Maju Jaya',
                        style: TextStyle(color: AppColors.muted)),
                  ),
                  const SizedBox(height: 5),
                  const Center(
                    child: Text('Rp28.000',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w800)),
                  ),
                  const Center(
                    child: Text('Pindai untuk membayar pesanan ini',
                        style: TextStyle(color: AppColors.muted, fontSize: 11)),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text('QRIS',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                            Spacer(),
                            Text('Midtrans · Sandbox',
                                style: TextStyle(
                                    color: AppColors.muted, fontSize: 10)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 210,
                          height: 210,
                          color: Colors.white,
                          child: const Icon(Icons.qr_code_2,
                              size: 190, color: AppColors.tealDark),
                        ),
                        const SizedBox(height: 12),
                        const Text('Ilustrasi sandbox · Tidak untuk pembayaran',
                            style: TextStyle(
                                color: AppColors.muted, fontSize: 10)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.tealSoft,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Row(
                      children: [
                        Text('Sisa waktu pembayaran\nBatas awal 15 menit',
                            style: TextStyle(
                                color: AppColors.muted, fontSize: 10)),
                        Spacer(),
                        Text('14:32',
                            style: TextStyle(
                                color: AppColors.teal,
                                fontSize: 20,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Center(
                    child: Text('◌  Menunggu pembayaran',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text('Status diperbarui otomatis setelah verifikasi server. '
                        'Tidak perlu konfirmasi manual.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.muted, fontSize: 10)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReceiptScreen()),
                ),
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44)),
                child: const Text('Simulasikan pembayaran berhasil'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
