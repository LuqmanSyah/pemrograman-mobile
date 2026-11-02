import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/pos_widgets.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final _barcodeController = TextEditingController();

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  void _searchBarcode() {
    if (_barcodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan kode barcode terlebih dahulu.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk ditemukan dan ditambahkan.')),
    );
    Navigator.pop(context);
  }

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Shift pagi',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                children: [
                  const Text(
                    'Pemindai Produk',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Arahkan kamera ke barcode produk',
                    style: TextStyle(color: AppColors.muted, fontSize: 11),
                  ),
                  const SizedBox(height: 12),
                  _ScannerPreview(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.flash_on_outlined, size: 17),
                          label: const Text('Flash'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.photo_library_outlined,
                            size: 17,
                          ),
                          label: const Text('Galeri'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Atau masukkan kode barcode',
                    style: TextStyle(color: AppColors.muted, fontSize: 11),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _barcodeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Masukkan kode barcode',
                          ),
                          onSubmitted: (_) => _searchBarcode(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: _searchBarcode,
                          child: const Text('Cari'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Center(
                    child: Text(
                      'Produk ditemukan akan ditambahkan ke keranjang',
                      style: TextStyle(color: AppColors.muted, fontSize: 11),
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

class _ScannerPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Container(
          width: 190,
          height: 132,
          decoration: BoxDecoration(
            color: const Color(0xFFCBD6E4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Container(
              width: 138,
              height: 78,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Divider(
                  color: AppColors.primary,
                  thickness: 2,
                  indent: 8,
                  endIndent: 8,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
