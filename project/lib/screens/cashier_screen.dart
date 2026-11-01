import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/pos_widgets.dart';
import 'payment_screen.dart';
import 'scanner_screen.dart';

class CashierScreen extends StatelessWidget {
  const CashierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PosHeader(
              title: 'Kasir',
              subtitle: 'Toko Maju Jaya · Rina',
              action: CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.tealSoft,
                child: const Text('R', style: TextStyle(color: AppColors.teal)),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      const Text('MJ-261101-0042',
                          style: TextStyle(color: AppColors.muted, fontSize: 10)),
                      const Spacer(),
                      const Icon(Icons.circle, size: 7, color: AppColors.teal),
                      const SizedBox(width: 4),
                      const Text('Online',
                          style: TextStyle(color: AppColors.teal, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari nama produk atau SKU',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 9),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScannerScreen()),
                    ),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Scan barcode'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      foregroundColor: AppColors.teal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Keranjang',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      const Spacer(),
                      Text('3 jenis · 4 unit',
                          style: const TextStyle(
                              color: AppColors.muted, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final product in products) ...[
                    ProductTile(product: product),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                children: [
                  const SummaryCard(),
                  const SizedBox(height: 10),
                  PrimaryButton(
                    label: 'Bayar',
                    icon: Icons.arrow_forward,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PaymentScreen()),
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
