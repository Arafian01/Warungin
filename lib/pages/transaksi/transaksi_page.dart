import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/barang_model.dart';
import '../../models/barang_satuan_model.dart';
import '../../providers/barang_provider.dart';
import '../../providers/barang_satuan_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/kategori_provider.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../utils/helpers.dart';
import '../../widgets/animated_search_header.dart';
import '../../widgets/category_filter_modal.dart';
import 'cart_page.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({Key? key}) : super(key: key);

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  String _searchQuery = '';
  String? _selectedCategoryId;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BarangSatuanProvider>(context, listen: false).loadAllBarangSatuan();
    });
  }


  @override
  Widget build(BuildContext context) {
    final kategoriProvider = Provider.of<KategoriProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: AnimatedSearchHeader(
          title: 'Transaksi Baru',
          onSearchChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
          showFilter: true,
          onFilterPressed: () async {
            final kategoriStream = kategoriProvider.getKategoriStream();
            final kategoriList = await kategoriStream.first;
            if (context.mounted) {
              showCategoryFilterModal(
                context,
                categories: kategoriList,
                selectedCategoryId: _selectedCategoryId,
                onCategorySelected: (categoryId) {
                  setState(() {
                    _selectedCategoryId = categoryId;
                  });
                },
              );
            }
          },
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 56,
      ),
      body: StreamBuilder<List<BarangModel>>(
        stream: Provider.of<BarangProvider>(context, listen: false).getBarangStream(),
        builder: (context, barangSnapshot) {
          if (barangSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (barangSnapshot.hasError) {
            return Center(
              child: Text('Error loading barang: ${barangSnapshot.error}'),
            );
          }

          final barangList = barangSnapshot.data ?? [];

          return Consumer<BarangSatuanProvider>(
            builder: (context, satuanProv, _) {
              if (satuanProv.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Group satuan by barang
              Map<String, List<BarangSatuanModel>> groupedSatuan = {};
              for (var satuan in satuanProv.barangSatuanList) {
                if (!groupedSatuan.containsKey(satuan.idBarang)) {
                  groupedSatuan[satuan.idBarang] = [];
                }
                groupedSatuan[satuan.idBarang]!.add(satuan);
              }

              // Filter by category and search
              var filteredBarang = barangList.where((barang) {
                // Category filter
                if (_selectedCategoryId != null && barang.idKategori != _selectedCategoryId) {
                  return false;
                }
                // Search filter
                if (_searchQuery.isEmpty) return true;
                return barang.namaBarang.toLowerCase().contains(_searchQuery);
              }).where((barang) {
                // Only show barang that has satuan
                return groupedSatuan.containsKey(barang.id);
              }).toList();

              if (filteredBarang.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 80,
                        color: AppColors.textSecondary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada barang',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tambahkan satuan pada barang terlebih dahulu',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                itemCount: filteredBarang.length,
                itemBuilder: (context, index) {
                  final barang = filteredBarang[index];
                  final satuanList = groupedSatuan[barang.id] ?? [];

                  return Card(
                    margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        barang.namaBarang,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${satuanList.length} satuan tersedia',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      children: satuanList.map((satuan) {
                        return ListTile(
                          leading: const Icon(
                            Icons.scale_outlined,
                            color: AppColors.primary,
                          ),
                          title: Text(satuan.namaSatuan),
                          subtitle: Text(
                            Formatters.currency(satuan.hargaJual),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: ElevatedButton.icon(
                            onPressed: () => _addToCart(barang, satuan),
                            icon: const Icon(Icons.add_shopping_cart, size: 18),
                            label: const Text('Tambah'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CartPage(),
                ),
              );
            },
            backgroundColor: AppColors.primary,
            child: Badge(
              label: Text('${cartProvider.itemCount}'),
              isLabelVisible: cartProvider.itemCount > 0,
              child: const Icon(Icons.shopping_cart),
            ),
          );
        },
      ),
    );
  }

  void _addToCart(BarangModel barang, BarangSatuanModel satuan) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addItem(satuan, barang, 1);
    
    Helpers.showSuccess(
      context,
      '${barang.namaBarang} (${satuan.namaSatuan}) ditambahkan ke keranjang',
    );
  }
}
