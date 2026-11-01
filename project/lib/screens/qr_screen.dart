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
              subtitle: 'Langkah 3 dari 4',
              showBack: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Center(child: Text('Menunggu pembayaran',
                      style: TextStyle(fontWeight: FontWeight.w700))),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text('Rp82.000',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w800)),
                  ),
                  const Center(
                    child: Text('Order INV-20261101-0042',
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
                        const SizedBox(height: 4),
                        Container(
                          width: 210,
                          height: 210,
                          color: Colors.white,
                          child: const Icon(Icons.qr_code_2,
                              size: 190, color: AppColors.navy),
                        ),
                        const SizedBox(height: 12),
                        const Text('Scan QR dengan aplikasi pembayaran pelanggan',
                            style: TextStyle(
                                color: AppColors.muted, fontSize: 10)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5FA),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Row(
                      children: [
                        Text('Kedaluwarsa dalam',
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
