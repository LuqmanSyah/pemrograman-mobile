import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';

class PosHeader extends StatelessWidget {
  const PosHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.action,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 21),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 32),
            ),
          if (showBack) const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w800)),
                if (subtitle != null)
                  Text(subtitle!,
                      style: const TextStyle(
                          color: AppColors.muted, fontSize: 11)),
              ],
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 19),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: product.sku == 'A01'
                      ? const Color(0xFFFFF0BE)
                      : product.sku == 'B02'
                          ? const Color(0xFFFFE9CF)
                          : const Color(0xFFC9F5FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(product.sku,
                    style: const TextStyle(
                        color: AppColors.warning, fontSize: 11,
                        fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(product.name,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              Text(formatRupiah(product.total),
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${product.quantity} x ${formatRupiah(product.price)}',
              style: const TextStyle(color: AppColors.muted, fontSize: 10),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Total pembayaran',
                  style: TextStyle(
                      color: AppColors.muted, fontSize: 11)),
              const Spacer(),
              Text(formatRupiah(82000),
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.w800)),
            ],
          ),
          if (compact) ...[
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.centerRight,
              child: Text('3 item',
                  style: TextStyle(color: AppColors.muted, fontSize: 11)),
            ),
          ],
        ],
      ),
    );
  }
}
