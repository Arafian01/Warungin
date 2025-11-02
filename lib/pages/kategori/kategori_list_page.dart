import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/kategori_provider.dart';
import '../../models/kategori_model.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/kategori_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/animated_search_header.dart';
import 'kategori_form_page.dart';

class KategoriListPage extends StatefulWidget {
  const KategoriListPage({Key? key}) : super(key: key);

  @override
  State<KategoriListPage> createState() => _KategoriListPageState();
}

class _KategoriListPageState extends State<KategoriListPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final kategoriProvider = Provider.of<KategoriProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: AnimatedSearchHeader(
          title: 'Kategori Barang',
          onSearchChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
          showFilter: false,
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 56,
      ),
      body: StreamBuilder<List<KategoriModel>>(
        stream: kategoriProvider.getKategoriStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator(message: 'Memuat kategori...');
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final allKategoriList = snapshot.data ?? [];
          
          // Filter categories based on search query
          final kategoriList = allKategoriList.where((kategori) {
            if (_searchQuery.isEmpty) return true;
            return kategori.namaKategori.toLowerCase().contains(_searchQuery) ||
                   (kategori.deskripsi?.toLowerCase().contains(_searchQuery) ?? false);
          }).toList();

          if (allKategoriList.isEmpty) {
            return EmptyState(
              icon: Icons.category_outlined,
              title: 'Belum Ada Kategori',
              message: 'Tambahkan kategori untuk mengelompokkan barang Anda',
              actionText: 'Tambah Kategori',
              onAction: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const KategoriFormPage(),
                  ),
                );
              },
            );
          }

          if (kategoriList.isEmpty && _searchQuery.isNotEmpty) {
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
                    'Kategori Tidak Ditemukan',
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
            itemCount: kategoriList.length,
            itemBuilder: (context, index) {
              final kategori = kategoriList[index];
              return KategoriCard(
                kategori: kategori,
                onEdit: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => KategoriFormPage(kategori: kategori),
                    ),
                  );
                },
                onDelete: () async {
                  final confirm = await Helpers.showConfirmDialog(
                    context,
                    title: 'Hapus Kategori',
                    message: 'Apakah Anda yakin ingin menghapus kategori ini?',
                  );

                  if (confirm && context.mounted) {
                    final success = await kategoriProvider.deleteKategori(kategori.id!);
                    if (context.mounted) {
                      if (success) {
                        Helpers.showSuccess(context, 'Kategori berhasil dihapus');
                      } else {
                        Helpers.showError(
                          context,
                          kategoriProvider.errorMessage ?? 'Gagal menghapus kategori',
                        );
                      }
                    }
                  }
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
              builder: (_) => const KategoriFormPage(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
