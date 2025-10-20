import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/barang_provider.dart';
import '../../providers/kategori_provider.dart';
import '../../models/barang_model.dart';
import '../../models/kategori_model.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class BarangFormPage extends StatefulWidget {
  final BarangModel? barang;

  const BarangFormPage({Key? key, this.barang}) : super(key: key);

  @override
  State<BarangFormPage> createState() => _BarangFormPageState();
}

class _BarangFormPageState extends State<BarangFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  
  String? _selectedKategoriId;

  bool get isEdit => widget.barang != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _namaController.text = widget.barang!.namaBarang;
      _selectedKategoriId = widget.barang!.idKategori;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedKategoriId == null) {
      Helpers.showError(context, 'Pilih kategori terlebih dahulu');
      return;
    }

    Helpers.dismissKeyboard(context);

    final barangProvider = Provider.of<BarangProvider>(context, listen: false);
    
    final barang = BarangModel(
      id: widget.barang?.id,
      idKategori: _selectedKategoriId!,
      namaBarang: _namaController.text.trim(),
      createdAt: widget.barang?.createdAt,
    );

    bool success;
    if (isEdit) {
      success = await barangProvider.updateBarang(widget.barang!.id!, barang);
    } else {
      success = await barangProvider.createBarang(barang);
    }

    if (!mounted) return;

    if (success) {
      Helpers.showSuccess(
        context,
        isEdit ? 'Barang berhasil diupdate' : 'Barang berhasil ditambahkan',
      );
      Navigator.of(context).pop();
    } else {
      Helpers.showError(
        context,
        barangProvider.errorMessage ?? 'Gagal menyimpan barang',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final kategoriProvider = Provider.of<KategoriProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isEdit ? 'Edit Barang' : 'Tambah Barang',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kategori dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kategori',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StreamBuilder<List<KategoriModel>>(
                    stream: kategoriProvider.getKategoriStream(),
                    builder: (context, snapshot) {
                      final kategoriList = snapshot.data ?? [];
                      
                      if (kategoriList.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                            border: Border.all(color: AppColors.warning),
                          ),
                          child: const Text(
                            'Belum ada kategori. Tambahkan kategori terlebih dahulu.',
                            style: TextStyle(color: AppColors.warning),
                          ),
                        );
                      }

                      return DropdownButtonFormField<String>(
                        value: _selectedKategoriId,
                        decoration: InputDecoration(
                          hintText: 'Pilih kategori',
                          prefixIcon: const Icon(Icons.category_outlined),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                            borderSide: const BorderSide(color: AppColors.divider),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                            borderSide: const BorderSide(color: AppColors.divider),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                        items: kategoriList.map((kategori) {
                          return DropdownMenuItem(
                            value: kategori.id,
                            child: Text(kategori.namaKategori),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedKategoriId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih kategori';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Nama Barang',
                hint: 'Contoh: Indomie Goreng',
                controller: _namaController,
                validator: (value) => Validators.required(value, fieldName: 'Nama barang'),
                prefixIcon: const Icon(Icons.inventory_2_outlined),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 32),
              
              Consumer<BarangProvider>(
                builder: (context, barangProvider, _) {
                  return CustomButton(
                    text: isEdit ? 'Update' : 'Simpan',
                    onPressed: _handleSubmit,
                    isLoading: barangProvider.isLoading,
                    icon: isEdit ? Icons.check : Icons.add,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
