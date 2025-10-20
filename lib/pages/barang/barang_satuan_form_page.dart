import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/barang_model.dart';
import '../../models/barang_satuan_model.dart';
import '../../providers/barang_satuan_provider.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class BarangSatuanFormPage extends StatefulWidget {
  final BarangModel barang;
  final BarangSatuanModel? barangSatuan;

  const BarangSatuanFormPage({
    Key? key,
    required this.barang,
    this.barangSatuan,
  }) : super(key: key);

  @override
  State<BarangSatuanFormPage> createState() => _BarangSatuanFormPageState();
}

class _BarangSatuanFormPageState extends State<BarangSatuanFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaSatuanController = TextEditingController();
  final _hargaController = TextEditingController();

  bool get isEdit => widget.barangSatuan != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _namaSatuanController.text = widget.barangSatuan!.namaSatuan;
      _hargaController.text = widget.barangSatuan!.hargaJual.toString();
    }
  }

  @override
  void dispose() {
    _namaSatuanController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    Helpers.dismissKeyboard(context);

    final provider = Provider.of<BarangSatuanProvider>(context, listen: false);

    final barangSatuan = BarangSatuanModel(
      id: widget.barangSatuan?.id,
      idBarang: widget.barang.id!,
      namaSatuan: _namaSatuanController.text.trim(),
      hargaJual: double.parse(_hargaController.text),
      createdAt: widget.barangSatuan?.createdAt,
    );

    bool success;
    if (isEdit) {
      success = await provider.updateBarangSatuan(
        widget.barangSatuan!.id!,
        barangSatuan,
      );
    } else {
      success = await provider.createBarangSatuan(barangSatuan);
    }

    if (!mounted) return;

    if (success) {
      Helpers.showSuccess(
        context,
        isEdit ? 'Satuan berhasil diupdate' : 'Satuan berhasil ditambahkan',
      );
      Navigator.of(context).pop();
    } else {
      Helpers.showError(
        context,
        provider.errorMessage ?? 'Gagal menyimpan satuan',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Satuan' : 'Tambah Satuan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.marginLarge),
          children: [
            // Info Barang
            Container(
              padding: const EdgeInsets.all(AppDimensions.marginMedium),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Barang',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          widget.barang.namaBarang,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Nama Satuan
            CustomTextField(
              label: 'Nama Satuan',
              hint: 'Contoh: pcs, dus, karton, kg',
              controller: _namaSatuanController,
              validator: (value) => Validators.required(value, fieldName: 'Nama satuan'),
              prefixIcon: const Icon(Icons.scale_outlined),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Harga Jual
            CustomTextField(
              label: 'Harga Jual',
              hint: 'Contoh: 3000',
              controller: _hargaController,
              keyboardType: TextInputType.number,
              validator: (value) => Validators.positiveNumber(value, fieldName: 'Harga jual'),
              prefixIcon: const Icon(Icons.attach_money),
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 32),

            // Submit Button
            Consumer<BarangSatuanProvider>(
              builder: (context, provider, _) {
                return CustomButton(
                  text: isEdit ? 'Update' : 'Simpan',
                  onPressed: _handleSubmit,
                  isLoading: provider.isLoading,
                  icon: isEdit ? Icons.check : Icons.add,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
