import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/transaksi_provider.dart';
import '../../models/transaksi_model.dart';
import '../../models/detail_transaksi_model.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../riwayat/riwayat_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _catatanController = TextEditingController();

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              if (cart.items.isEmpty) return const SizedBox();
              return TextButton.icon(
                onPressed: () => _clearCart(),
                icon: const Icon(Icons.delete_sweep, color: Colors.white),
                label: const Text(
                  'Kosongkan',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Keranjang Kosong',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan barang untuk memulai transaksi',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.marginMedium),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppDimensions.marginMedium),
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.marginMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.barang.namaBarang,
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${item.barangSatuan.namaSatuan} @ ${Formatters.currency(item.barangSatuan.hargaJual)}',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    cart.removeItem(item.barangSatuan.id!);
                                  },
                                  icon: const Icon(Icons.delete_outline),
                                  color: AppColors.error,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (item.jumlah > 1) {
                                          cart.updateItemQuantity(
                                            item.barangSatuan.id!,
                                            item.jumlah - 1,
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.remove_circle_outline),
                                      color: AppColors.primary,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${item.jumlah}',
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        cart.updateItemQuantity(
                                          item.barangSatuan.id!,
                                          item.jumlah + 1,
                                        );
                                      },
                                      icon: const Icon(Icons.add_circle_outline),
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                                Text(
                                  Formatters.currency(item.subtotal),
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Bottom Section
              Container(
                padding: const EdgeInsets.all(AppDimensions.marginLarge),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Total Harga
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Harga',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            Formatters.currency(cart.totalAmount),
                            style: AppTextStyles.heading2.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Deskripsi
                    TextField(
                      controller: _catatanController,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi',
                        hintText: 'Masukkan deskripsi transaksi (opsional)',
                        prefixIcon: const Icon(Icons.description_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                          borderSide: BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    
                    // Checkout Button
                    Consumer<TransaksiProvider>(
                      builder: (context, transaksiProv, _) {
                        return SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: 'Checkout',
                            onPressed: () => _handleCheckout(cart),
                            isLoading: transaksiProv.isLoading,
                            icon: Icons.check_circle_outline,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _clearCart() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kosongkan Keranjang'),
        content: const Text('Yakin ingin menghapus semua item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Provider.of<CartProvider>(context, listen: false).clearCart();
    }
  }

  Future<void> _handleCheckout(CartProvider cart) async {
    if (cart.items.isEmpty) return;

    final transaksiProvider = Provider.of<TransaksiProvider>(context, listen: false);

    // Create transaksi
    final transaksi = TransaksiModel(
      totalHarga: cart.totalAmount,
      tanggal: DateTime.now(),
      catatan: _catatanController.text.isEmpty ? null : _catatanController.text,
    );

    // Create detail transaksi
    final details = cart.items.map((item) {
      return DetailTransaksiModel(
        idTransaksi: '',
        idBarangSatuan: item.barangSatuan.id!,
        idBarang: item.barang.id!,
        namaBarang: item.barang.namaBarang,
        jumlah: item.jumlah,
      );
    }).toList();

    final success = await transaksiProvider.createTransaksi(transaksi, details);

    if (!mounted) return;

    if (success) {
      cart.clearCart();
      Helpers.showSuccess(context, 'Transaksi berhasil disimpan');
      
      // Navigate to riwayat
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const RiwayatPage()),
        (route) => route.isFirst,
      );
    } else {
      Helpers.showError(
        context,
        transaksiProvider.errorMessage ?? 'Gagal menyimpan transaksi',
      );
    }
  }
}
