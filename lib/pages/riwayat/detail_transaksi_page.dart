import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaksi_provider.dart';
import '../../models/transaksi_model.dart';
import '../../models/detail_transaksi_model.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/loading_indicator.dart';

class DetailTransaksiPage extends StatefulWidget {
  final TransaksiModel transaksi;

  const DetailTransaksiPage({Key? key, required this.transaksi}) : super(key: key);

  @override
  State<DetailTransaksiPage> createState() => _DetailTransaksiPageState();
}

class _DetailTransaksiPageState extends State<DetailTransaksiPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transaksiProvider = Provider.of<TransaksiProvider>(context, listen: false);
      transaksiProvider.loadDetailTransaksi(widget.transaksi.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detail Transaksi',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction info
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        Formatters.currency(widget.transaksi.totalHarga),
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildInfoRow('Tanggal', Formatters.dateTime(widget.transaksi.tanggal)),
                  const SizedBox(height: 8),
                  _buildInfoRow('Metode', 'Tunai'), // Default since metode not in model
                  if (widget.transaksi.catatan != null && widget.transaksi.catatan!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow('Catatan', widget.transaksi.catatan!),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Items header
            Text(
              'Detail Barang',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            
            // Items list
            Consumer<TransaksiProvider>(
              builder: (context, transaksiProvider, _) {
                if (transaksiProvider.isLoading) {
                  return const LoadingIndicator(message: 'Memuat detail...');
                }

                final details = transaksiProvider.currentDetails;

                if (details.isEmpty) {
                  return const CustomCard(
                    child: Center(
                      child: Text('Tidak ada detail barang'),
                    ),
                  );
                }

                return Column(
                  children: details.map((detail) {
                    return CustomCard(
                      margin: const EdgeInsets.only(bottom: AppDimensions.marginSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.namaBarang,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Jumlah: ${detail.jumlah}', // hargaSatuan not available
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '${detail.jumlah} item', // subtotal not available
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
