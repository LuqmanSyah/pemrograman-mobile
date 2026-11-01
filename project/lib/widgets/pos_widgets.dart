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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
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
                        fontSize: 18, fontWeight: FontWeight.w700)),
                if (subtitle != null)
                  Text(subtitle!,
                      style: const TextStyle(
                          color: AppColors.muted, fontSize: 10)),
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
      height: 48,
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
      padding: const EdgeInsets.fromLTRB(7, 9, 9, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(product.name,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              const Icon(Icons.delete_outline, size: 18, color: AppColors.muted),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${formatRupiah(product.price)} / unit · SKU ${product.sku}',
              style: const TextStyle(color: AppColors.muted, fontSize: 10),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.tealSoft,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  children: [
                    _quantityButton(Icons.remove),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text('${product.quantity}'),
                    ),
                    _quantityButton(Icons.add),
                  ],
                ),
              ),
              const Spacer(),
              Text(formatRupiah(product.total),
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon) => SizedBox(
        width: 34,
        height: 32,
        child: Icon(icon, size: 16),
      );
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('3 jenis barang · 4 unit',
                  style: TextStyle(color: AppColors.muted, fontSize: 11)),
              const Spacer(),
              Text(formatRupiah(28000),
                  style: const TextStyle(color: AppColors.muted, fontSize: 11)),
            ],
          ),
          if (!compact) const SizedBox(height: 8),
          Row(
            children: [
              const Text('Total pembayaran',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              Text(formatRupiah(28000),
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}
