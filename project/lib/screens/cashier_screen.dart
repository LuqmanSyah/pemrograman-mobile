import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/pos_widgets.dart';
import 'payment_screen.dart';

class CashierScreen extends StatelessWidget {
  const CashierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PosHeader(
              title: 'KASIRKU',
              subtitle: 'Outlet Sudirman',
              action: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Shift pagi',
                    style: TextStyle(color: AppColors.primary, fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      const SizedBox.shrink(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari produk atau barcode',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: const Text('Keranjang',
                            style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                      Text('3 item',
                          style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                      const SizedBox(width: 16),
                      Text('Kosongkan',
                          style: TextStyle(color: Colors.red.shade600,
                              fontSize: 11, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                    label: 'Lanjut ke pembayaran',
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
