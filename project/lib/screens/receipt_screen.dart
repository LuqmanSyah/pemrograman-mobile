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
            PosHeader(
              title: 'Pembayaran QRIS berhasil',
              subtitle: '01 Nov 2026 • Kasir Rina',
              action: CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.tealSoft,
                child: const Text('K', style: TextStyle(color: AppColors.primary)),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.success),
                      SizedBox(width: 8),
                      Text(
                        'Pembayaran QRIS berhasil',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Stok diperbarui otomatis',
                    style: TextStyle(color: AppColors.muted, fontSize: 11),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'TOKO MAJU JAYA',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'Struk pembayaran',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 9,
                            ),
                          ),
                        ),
                        const Divider(height: 22),
                        _receiptRow('ID transaksi', 'MJ-261101-0042'),
                        _receiptRow('Tanggal', '1 Nov 2026 · 09.44'),
                        _receiptRow('Kasir', 'Rina'),
                        const Divider(height: 22),
                        _receiptRow(
                          'Kopi Susu Gula Aren',
                          'Rp30.000',
                          detail: '2 x Rp15.000',
                        ),
                        _receiptRow(
                          'Nasi Goreng Spesial',
                          'Rp28.000',
                          detail: '1 x Rp28.000',
                        ),
                        _receiptRow(
                          'Es Teh Lemon',
                          'Rp24.000',
                          detail: '2 x Rp12.000',
                        ),
                        const Divider(height: 22),
                        _receiptRow('Total', formatRupiah(82000), bold: true),
                        const SizedBox(height: 12),
                        _receiptRow('Metode', 'QRIS • LUNAS'),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'Terima kasih telah berbelanja.',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download_outlined),
                          label: const Text('Simpan PDF'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined),
                          label: const Text('Bagikan'),
                        ),
                      ),
                    ],
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
                  (route) => false,
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
