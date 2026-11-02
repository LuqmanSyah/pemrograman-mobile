import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/pos_widgets.dart';
import 'qr_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _method = 'QRIS';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PosHeader(
              title: 'Pembayaran',
              subtitle: 'Langkah 2 dari 4',
              showBack: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SummaryCard(compact: true),
                  const SizedBox(height: 18),
                  const Text(
                    'Metode pembayaran',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _PaymentOption(
                    title: 'Tunai',
                    subtitle: 'Bayar langsung di kasir',
                    icon: Icons.payments_outlined,
                    selected: _method == 'Tunai',
                    onTap: () => setState(() => _method = 'Tunai'),
                  ),
                  const SizedBox(height: 9),
                  _PaymentOption(
                    title: 'QRIS',
                    subtitle: 'Digital • Midtrans sandbox',
                    icon: Icons.qr_code_2,
                    selected: _method == 'QRIS',
                    onTap: () => setState(() => _method = 'QRIS'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: PrimaryButton(
                label: _method == 'QRIS' ? 'Lanjut ke QRIS' : 'Bayar Tunai',
                icon: Icons.arrow_forward,
                onPressed: () {
                  if (_method == 'QRIS') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QrScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pembayaran tunai berhasil.'),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected ? AppColors.primarySoft : Colors.white,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
          width: selected ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: selected ? AppColors.primary : AppColors.muted),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ],
      ),
    ),
  );
}
