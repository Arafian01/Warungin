import 'package:flutter/material.dart';
import '../models/kategori_model.dart';
import '../utils/constants.dart';
import 'custom_card.dart';

class KategoriCard extends StatelessWidget {
  final KategoriModel kategori;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const KategoriCard({
    Key? key,
    required this.kategori,
    this.onTap,
    this.onEdit,
    this.onDelete,
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
              Icons.category_outlined,
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
                  kategori.namaKategori,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (kategori.deskripsi != null && kategori.deskripsi!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    kategori.deskripsi!,
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          
          // Actions
          if (showActions) ...[
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
