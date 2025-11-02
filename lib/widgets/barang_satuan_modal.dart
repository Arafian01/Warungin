import 'package:flutter/material.dart';
import '../models/barang_model.dart';
import '../models/barang_satuan_model.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class BarangSatuanModal extends StatelessWidget {
  final BarangModel barang;
  final List<BarangSatuanModel> satuanList;
  final Function(BarangSatuanModel) onAddToCart;

  const BarangSatuanModal({
    Key? key,
    required this.barang,
    required this.satuanList,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  radius: 30,
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        barang.namaBarang,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${satuanList.length} satuan tersedia',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          
          // Divider
          const Divider(height: 1),
          
          // Satuan List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: satuanList.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final satuan = satuanList[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.scale_outlined,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    satuan.namaSatuan,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      Formatters.currency(satuan.hargaJual),
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  trailing: ElevatedButton.icon(
                    onPressed: () {
                      onAddToCart(satuan);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Tambah',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Bottom Padding
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required BarangModel barang,
    required List<BarangSatuanModel> satuanList,
    required Function(BarangSatuanModel) onAddToCart,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BarangSatuanModal(
        barang: barang,
        satuanList: satuanList,
        onAddToCart: onAddToCart,
      ),
    );
  }
}
