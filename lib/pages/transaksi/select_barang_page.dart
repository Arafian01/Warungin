import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/barang_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/barang_model.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../utils/helpers.dart';
import '../../utils/validators.dart';
import '../../widgets/barang_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SelectBarangPage extends StatefulWidget {
  const SelectBarangPage({Key? key}) : super(key: key);

  @override
  State<SelectBarangPage> createState() => _SelectBarangPageState();
}

class _SelectBarangPageState extends State<SelectBarangPage> {
  String _searchQuery = '';

  void _showAddToCartDialog(BuildContext context, BarangModel barang) {
    final jumlahController = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(barang.namaBarang),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${Formatters.currency(barang.harga)} / ${barang.satuan}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Jumlah',
                controller: jumlahController,
                keyboardType: TextInputType.number,
                validator: (value) => Validators.positiveInteger(value, fieldName: 'Jumlah'),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final jumlah = int.parse(jumlahController.text);
                final cartProvider = Provider.of<CartProvider>(context, listen: false);
                cartProvider.addItem(barang, jumlah);
                Navigator.of(dialogContext).pop();
                Helpers.showSuccess(context, 'Barang ditambahkan ke keranjang');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final barangProvider = Provider.of<BarangProvider>(context);

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
          'Pilih Barang',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari barang...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          
          // Barang list
          Expanded(
            child: StreamBuilder<List<BarangModel>>(
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

                var barangList = snapshot.data ?? [];
                
                // Filter by search query
                if (_searchQuery.isNotEmpty) {
                  barangList = barangList.where((barang) {
                    return barang.namaBarang.toLowerCase().contains(_searchQuery);
                  }).toList();
                }

                if (barangList.isEmpty) {
                  return EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: _searchQuery.isEmpty ? 'Belum Ada Barang' : 'Barang Tidak Ditemukan',
                    message: _searchQuery.isEmpty
                        ? 'Tambahkan barang terlebih dahulu'
                        : 'Coba kata kunci lain',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  itemCount: barangList.length,
                  itemBuilder: (context, index) {
                    final barang = barangList[index];
                    return BarangCard(
                      barang: barang,
                      showActions: false,
                      onTap: () => _showAddToCartDialog(context, barang),
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
}
