import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/kategori_provider.dart';
import '../../models/kategori_model.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/kategori_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_indicator.dart';
import 'kategori_form_page.dart';

class KategoriListPage extends StatelessWidget {
  const KategoriListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kategoriProvider = Provider.of<KategoriProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Kategori Barang',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
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

          final kategoriList = snapshot.data ?? [];

          if (kategoriList.isEmpty) {
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
