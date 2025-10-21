import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/barang_provider.dart';
import '../../providers/kategori_provider.dart';
import '../../models/barang_model.dart';
import '../../models/kategori_model.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/barang_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_indicator.dart';
import 'barang_form_page.dart';
import 'barang_satuan_list_page.dart';

class BarangListPage extends StatefulWidget {
  const BarangListPage({Key? key}) : super(key: key);

  @override
  State<BarangListPage> createState() => _BarangListPageState();
}

class _BarangListPageState extends State<BarangListPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final barangProvider = Provider.of<BarangProvider>(context);
    final kategoriProvider = Provider.of<KategoriProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Daftar Barang',
          style: TextStyle(color: Colors.white),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari barang...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<BarangModel>>(
        stream: barangProvider.getBarangStream(),
        builder: (context, barangSnapshot) {
          if (barangSnapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator(message: 'Memuat barang...');
          }

          if (barangSnapshot.hasError) {
            return Center(
              child: Text('Error: ${barangSnapshot.error}'),
            );
          }

          final allBarangList = barangSnapshot.data ?? [];

          if (allBarangList.isEmpty) {
            return EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'Belum Ada Barang',
              message: 'Tambahkan barang untuk memulai transaksi',
              actionText: 'Tambah Barang',
              onAction: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const BarangFormPage(),
                  ),
                );
              },
            );
          }

          return StreamBuilder<List<KategoriModel>>(
            stream: kategoriProvider.getKategoriStream(),
            builder: (context, kategoriSnapshot) {
              final kategoriList = kategoriSnapshot.data ?? [];
              
              // Create a map for quick category lookup
              Map<String, String> kategoriMap = {};
              for (var kategori in kategoriList) {
                if (kategori.id != null) {
                  kategoriMap[kategori.id!] = kategori.namaKategori;
                }
              }

              // Filter barang based on search query
              final barangList = allBarangList.where((barang) {
                if (_searchQuery.isEmpty) return true;
                final kategoriName = kategoriMap[barang.idKategori]?.toLowerCase() ?? '';
                return barang.namaBarang.toLowerCase().contains(_searchQuery) ||
                       kategoriName.contains(_searchQuery);
              }).toList();

              if (barangList.isEmpty && _searchQuery.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 80,
                        color: AppColors.textSecondary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Barang Tidak Ditemukan',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Coba kata kunci yang berbeda',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                itemCount: barangList.length,
                itemBuilder: (context, index) {
                  final barang = barangList[index];
                  final kategoriName = kategoriMap[barang.idKategori];
                  
                  return BarangCard(
                    barang: barang,
                    kategoriName: kategoriName,
                onKelolaSatuan: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BarangSatuanListPage(barang: barang),
                    ),
                  );
                },
                onEdit: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BarangFormPage(barang: barang),
                    ),
                  );
                },
                onDelete: () async {
                  final confirm = await Helpers.showConfirmDialog(
                    context,
                    title: 'Hapus Barang',
                    message: 'Apakah Anda yakin ingin menghapus barang ini?',
                  );

                  if (confirm && context.mounted) {
                    final success = await barangProvider.deleteBarang(barang.id!);
                    if (context.mounted) {
                      if (success) {
                        Helpers.showSuccess(context, 'Barang berhasil dihapus');
                      } else {
                        Helpers.showError(
                          context,
                          barangProvider.errorMessage ?? 'Gagal menghapus barang',
                        );
                      }
                    }
                  }
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const BarangFormPage(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
