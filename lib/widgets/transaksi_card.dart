import 'package:flutter/material.dart';
import '../models/transaksi_model.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import 'custom_card.dart';

class TransaksiCard extends StatelessWidget {
  final TransaksiModel transaksi;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showActions;

  const TransaksiCard({
    Key? key,
    required this.transaksi,
    this.onTap,
    this.onDelete,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: AppDimensions.marginSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDimensions.marginMedium),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Formatters.currency(transaksi.total),
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Formatters.dateTime(transaksi.tanggal),
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              
              // Actions
              if (showActions && onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.error,
                  iconSize: 20,
                ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.marginSmall),
          
          // Metode & Catatan
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  transaksi.metode,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (transaksi.catatan != null && transaksi.catatan!.isNotEmpty) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    transaksi.catatan!,
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
