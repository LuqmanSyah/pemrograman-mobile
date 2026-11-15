import 'package:flutter/material.dart';

import '../models/kegiatan.dart';
import '../state/pengaturan.dart';
import '../utils/format.dart';

class RingkasanCard extends StatelessWidget {
  const RingkasanCard({
    super.key,
    required this.summary,
    required this.settings,
  });
  final Ringkasan summary;
  final PengaturanState settings;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final negative = summary.tabungan < 0;
    final progress = (summary.tabungan / settings.target).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rupiah(summary.tabungan),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: negative ? colors.error : colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              negative
                  ? 'Peringatan: tabungan negatif'
                  : summary.tabungan >= settings.target
                  ? 'Target tercapai!'
                  : 'Target ${rupiah(settings.target)}',
              style: TextStyle(color: negative ? colors.error : null),
            ),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 500),
              builder: (_, value, _) => LinearProgressIndicator(value: value),
            ),
            const SizedBox(height: 12),
            Text(
              'Masuk ${rupiah(summary.masuk)}   •   Keluar ${rupiah(summary.keluar)}',
            ),
            Text('${summary.selesai}/${summary.jumlah} kegiatan selesai'),
          ],
        ),
      ),
    );
  }
}
