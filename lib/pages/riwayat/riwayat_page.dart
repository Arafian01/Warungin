import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaksi_provider.dart';
import '../../models/transaksi_model.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/transaksi_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_indicator.dart';
import 'detail_transaksi_page.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({Key? key}) : super(key: key);

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final transaksiProvider = Provider.of<TransaksiProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              _showSearchDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
              vertical: AppDimensions.paddingSmall,
            ),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Hari Ini', () {
                    // TODO: Filter by today
                  }),
                  const SizedBox(width: 8),
                  _buildFilterChip('Minggu Ini', () {
                    // TODO: Filter by this week
                  }),
                  const SizedBox(width: 8),
                  _buildFilterChip('Bulan Ini', () {
                    // TODO: Filter by this month
                  }),
                ],
              ),
            ),
          ),
          
          // Transaksi list
          Expanded(
            child: StreamBuilder<List<TransaksiModel>>(
              stream: transaksiProvider.getTransaksiStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingIndicator(message: 'Memuat riwayat...');
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final transaksiList = snapshot.data ?? [];

                if (transaksiList.isEmpty) {
                  return const EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'Belum Ada Transaksi',
                    message: 'Transaksi yang Anda buat akan muncul di sini',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  itemCount: transaksiList.length,
                  itemBuilder: (context, index) {
                    final transaksi = transaksiList[index];
                    return TransaksiCard(
                      transaksi: transaksi,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DetailTransaksiPage(transaksi: transaksi),
                          ),
                        );
                      },
                      onDelete: () async {
                        final confirm = await Helpers.showConfirmDialog(
                          context,
                          title: 'Hapus Transaksi',
                          message: 'Apakah Anda yakin ingin menghapus transaksi ini?',
                        );

                        if (confirm && context.mounted) {
                          final success = await transaksiProvider.deleteTransaksi(transaksi.id!);
                          if (context.mounted) {
                            if (success) {
                              Helpers.showSuccess(context, 'Transaksi berhasil dihapus');
                            } else {
                              Helpers.showError(
                                context,
                                transaksiProvider.errorMessage ?? 'Gagal menghapus transaksi',
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
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppColors.background,
      labelStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textPrimary,
      ),
    );
  }

  void _showSearchDialog() {
    final searchController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cari Transaksi'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Masukkan nama barang...',
            prefixIcon: Icon(Icons.search),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final query = searchController.text.trim();
              if (query.isNotEmpty) {
                final transaksiProvider = Provider.of<TransaksiProvider>(
                  context,
                  listen: false,
                );
                await transaksiProvider.searchTransaksiByItem(query);
                if (context.mounted) {
                  Navigator.of(dialogContext).pop();
                  // TODO: Show search results
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Cari'),
          ),
        ],
      ),
    );
  }
}
