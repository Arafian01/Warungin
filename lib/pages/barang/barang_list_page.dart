import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/barang_provider.dart';
import '../../models/barang_model.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/barang_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_indicator.dart';
import 'barang_form_page.dart';
import 'barang_satuan_list_page.dart';

class BarangListPage extends StatelessWidget {
  const BarangListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final barangProvider = Provider.of<BarangProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Daftar Barang',
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
      body: StreamBuilder<List<BarangModel>>(
        stream: barangProvider.getBarangStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator(message: 'Memuat barang...');
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final barangList = snapshot.data ?? [];

          if (barangList.isEmpty) {
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

          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            itemCount: barangList.length,
            itemBuilder: (context, index) {
              final barang = barangList[index];
              return BarangCard(
                barang: barang,
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
