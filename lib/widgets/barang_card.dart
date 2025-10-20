import 'package:flutter/material.dart';
import '../models/barang_model.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import 'custom_card.dart';

class BarangCard extends StatelessWidget {
  final BarangModel barang;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onKelolaSatuan;
  final bool showActions;

  const BarangCard({
    Key? key,
    required this.barang,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onKelolaSatuan,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: AppDimensions.marginSmall),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primary,
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
                  barang.namaBarang,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Kategori: ${barang.idKategori}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Actions
          if (showActions) ...[
            if (onKelolaSatuan != null)
              IconButton(
                onPressed: onKelolaSatuan,
                icon: const Icon(Icons.scale_outlined),
                color: AppColors.success,
                iconSize: 20,
                tooltip: 'Kelola Satuan',
              ),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
              color: AppColors.primary,
              iconSize: 20,
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              color: AppColors.error,
              iconSize: 20,
            ),
          ],
        ],
      ),
    );
  }
}
