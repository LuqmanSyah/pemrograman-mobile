import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/pos_widgets.dart';
import 'cashier_screen.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 32,
              backgroundColor: Color(0xFFD8F8E5),
              child: Icon(Icons.check, color: AppColors.success, size: 36),
            ),
            const SizedBox(height: 12),
            const Text(
              'Pembayaran QRIS berhasil',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const Text(
              '01 Nov 2026 • Kasir Rina',
              style: TextStyle(color: AppColors.muted, fontSize: 11),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'TOKO MAJU JAYA',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const Text(
                          'Struk pembayaran',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 10,
                          ),
                        ),
                        const Divider(height: 22),
                        for (final product in products)
                          _receiptRow(
                            product.name,
                            formatRupiah(product.total),
                            detail:
                                '${product.quantity} x ${formatRupiah(product.price)}',
                          ),
                        const Divider(height: 22),
                        _receiptRow('Total', formatRupiah(82000), bold: true),
                        _receiptRow('Metode', 'QRIS • LUNAS'),
                        const SizedBox(height: 8),
                        const Text(
                          'Stok diperbarui otomatis',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: PrimaryButton(
                label: 'Transaksi Baru',
                icon: Icons.add,
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const CashierScreen()),
                  (_) => false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receiptRow(
    String label,
    String value, {
    String? detail,
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
                if (detail != null)
                  Text(
                    detail,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
