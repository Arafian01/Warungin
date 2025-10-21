import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import 'custom_card.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRemove;

  const CartItemCard({
    Key? key,
    required this.item,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: AppDimensions.marginSmall),
      child: Row(
        children: [
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.barang.namaBarang,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${Formatters.currency(item.barangSatuan.hargaJual)} / ${item.barangSatuan.namaSatuan}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Subtotal: ${Formatters.currency(item.subtotal)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity controls
          Column(
            children: [
              Row(
                children: [
                  // Decrement
                  IconButton(
                    onPressed: onDecrement,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.primary,
                    iconSize: 24,
                  ),
                  
                  // Quantity
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${item.jumlah}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  // Increment
                  IconButton(
                    onPressed: onIncrement,
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.primary,
                    iconSize: 24,
                  ),
                ],
              ),
              
              // Remove button
              TextButton.icon(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Hapus'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
