import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/barang_provider.dart';
import '../../providers/transaksi_provider.dart';
import '../../models/barang_model.dart';
import '../../models/transaksi_model.dart';
import '../../models/detail_transaksi_model.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/cart_item_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_indicator.dart';
import 'select_barang_page.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({Key? key}) : super(key: key);

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  String _selectedMetode = PaymentMethods.cash;
  final _catatanController = TextEditingController();

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _handleCheckout() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    if (cartProvider.items.isEmpty) {
      Helpers.showError(context, 'Keranjang masih kosong');
      return;
    }

    final confirm = await Helpers.showConfirmDialog(
      context,
      title: 'Konfirmasi Transaksi',
      message: 'Total: ${Formatters.currency(cartProvider.totalAmount)}\nLanjutkan transaksi?',
    );

    if (!confirm) return;

    final transaksiProvider = Provider.of<TransaksiProvider>(context, listen: false);

    // Create transaksi
    final transaksi = TransaksiModel(
      tanggal: DateTime.now(),
      totalHarga: cartProvider.totalAmount,
      catatan: _catatanController.text.trim(),
    );

    // Create detail transaksi
    final details = cartProvider.items.map((item) {
      return DetailTransaksiModel(
        idTransaksi: '', // Will be set by service
        idBarangSatuan: item.barangSatuan.id!,
        idBarang: item.barang.id!,
        namaBarang: item.barang.namaBarang,
        jumlah: item.jumlah,
      );
    }).toList();

    final success = await transaksiProvider.createTransaksi(transaksi, details);

    if (!mounted) return;

    if (success) {
      Helpers.showSuccess(context, 'Transaksi berhasil disimpan');
      cartProvider.clearCart();
      _catatanController.clear();
      setState(() {
        _selectedMetode = PaymentMethods.cash;
      });
    } else {
      Helpers.showError(
        context,
        transaksiProvider.errorMessage ?? 'Gagal menyimpan transaksi',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Transaksi Baru',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              if (cartProvider.items.isEmpty) return const SizedBox();
              
              return TextButton.icon(
                onPressed: () {
                  cartProvider.clearCart();
                  Helpers.showSuccess(context, 'Keranjang dikosongkan');
                },
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
      body: Column(
        children: [
          // Cart items
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                if (cartProvider.items.isEmpty) {
                  return EmptyState(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Keranjang Kosong',
                    message: 'Tambahkan barang untuk memulai transaksi',
                    actionText: 'Pilih Barang',
                    onAction: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SelectBarangPage(),
                        ),
                      );
                    },
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  children: [
                    ...cartProvider.items.map((item) {
                      return CartItemCard(
                        item: item,
                        onIncrement: () {
                          cartProvider.updateItemQuantity(
                            item.barangSatuan.id!,
                            item.jumlah + 1,
                          );
                        },
                        onDecrement: () {
                          cartProvider.updateItemQuantity(
                            item.barangSatuan.id!,
                            item.jumlah - 1,
                          );
                        },
                        onRemove: () {
                          cartProvider.removeItem(item.barangSatuan.id!);
                          Helpers.showSuccess(context, 'Barang dihapus dari keranjang');
                        },
                      );
                    }).toList(),
                    
                    const SizedBox(height: 16),
                    
                    // Payment method
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Metode Pembayaran',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: PaymentMethods.getAll().map((metode) {
                              final isSelected = _selectedMetode == metode;
                              return ChoiceChip(
                                label: Text(metode),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedMetode = metode;
                                  });
                                },
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Notes
                    CustomCard(
                      child: TextField(
                        controller: _catatanController,
                        decoration: const InputDecoration(
                          labelText: 'Catatan (Opsional)',
                          hintText: 'Tambahkan catatan transaksi',
                          border: InputBorder.none,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          
          // Bottom summary
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              if (cartProvider.items.isEmpty) return const SizedBox();
              
              return Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total (${cartProvider.itemCount} item)',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            Formatters.currency(cartProvider.totalAmount),
                            style: AppTextStyles.heading3.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Consumer<TransaksiProvider>(
                        builder: (context, transaksiProvider, _) {
                          return CustomButton(
                            text: 'Proses Transaksi',
                            onPressed: _handleCheckout,
                            isLoading: transaksiProvider.isLoading,
                            icon: Icons.check_circle_outline,
                            width: double.infinity,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SelectBarangPage(),
                ),
              );
            },
            backgroundColor: AppColors.primary,
            child: Badge(
              label: Text('${cartProvider.itemCount}'),
              isLabelVisible: cartProvider.itemCount > 0,
              child: const Icon(Icons.add_shopping_cart),
            ),
          );
        },
      ),
    );
  }
}
