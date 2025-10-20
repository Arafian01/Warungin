import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/barang_model.dart';
import '../../models/barang_satuan_model.dart';
import '../../providers/barang_satuan_provider.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../utils/helpers.dart';
import 'barang_satuan_form_page.dart';

class BarangSatuanListPage extends StatefulWidget {
  final BarangModel barang;

  const BarangSatuanListPage({Key? key, required this.barang}) : super(key: key);

  @override
  State<BarangSatuanListPage> createState() => _BarangSatuanListPageState();
}

class _BarangSatuanListPageState extends State<BarangSatuanListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BarangSatuanProvider>(context, listen: false)
          .loadBarangSatuanByBarangId(widget.barang.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kelola Satuan'),
            Text(
              widget.barang.namaBarang,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<BarangSatuanProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.barangSatuanList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.scale_outlined,
                    size: 80,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada satuan',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan satuan untuk barang ini',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.marginMedium),
            itemCount: provider.barangSatuanList.length,
            itemBuilder: (context, index) {
              final satuan = provider.barangSatuanList[index];
              return _buildSatuanCard(satuan);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BarangSatuanFormPage(barang: widget.barang),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSatuanCard(BarangSatuanModel satuan) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.marginMedium),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: const Icon(
            Icons.scale_outlined,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          satuan.namaSatuan,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          Formatters.currency(satuan.hargaJual),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BarangSatuanFormPage(
                      barang: widget.barang,
                      barangSatuan: satuan,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined),
              color: AppColors.primary,
            ),
            IconButton(
              onPressed: () => _handleDelete(satuan),
              icon: const Icon(Icons.delete_outline),
              color: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDelete(BarangSatuanModel satuan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Satuan'),
        content: Text('Yakin ingin menghapus satuan "${satuan.namaSatuan}"?'),
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
      final provider = Provider.of<BarangSatuanProvider>(context, listen: false);
      final success = await provider.deleteBarangSatuan(satuan.id!);

      if (!mounted) return;

      if (success) {
        Helpers.showSuccess(context, 'Satuan berhasil dihapus');
      } else {
        Helpers.showError(context, provider.errorMessage ?? 'Gagal menghapus satuan');
      }
    }
  }
}
