import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/kategori_provider.dart';
import '../../models/kategori_model.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class KategoriFormPage extends StatefulWidget {
  final KategoriModel? kategori;

  const KategoriFormPage({Key? key, this.kategori}) : super(key: key);

  @override
  State<KategoriFormPage> createState() => _KategoriFormPageState();
}

class _KategoriFormPageState extends State<KategoriFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();

  bool get isEdit => widget.kategori != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _namaController.text = widget.kategori!.namaKategori;
      _deskripsiController.text = widget.kategori!.deskripsi ?? '';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    Helpers.dismissKeyboard(context);

    final kategoriProvider = Provider.of<KategoriProvider>(context, listen: false);
    
    final kategori = KategoriModel(
      id: widget.kategori?.id,
      namaKategori: _namaController.text.trim(),
      deskripsi: _deskripsiController.text.trim(),
      createdAt: widget.kategori?.createdAt,
    );

    bool success;
    if (isEdit) {
      success = await kategoriProvider.updateKategori(widget.kategori!.id!, kategori);
    } else {
      success = await kategoriProvider.createKategori(kategori);
    }

    if (!mounted) return;

    if (success) {
      Helpers.showSuccess(
        context,
        isEdit ? 'Kategori berhasil diupdate' : 'Kategori berhasil ditambahkan',
      );
      Navigator.of(context).pop();
    } else {
      Helpers.showError(
        context,
        kategoriProvider.errorMessage ?? 'Gagal menyimpan kategori',
      );
    }
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
        title: Text(
          isEdit ? 'Edit Kategori' : 'Tambah Kategori',
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
              CustomTextField(
                label: 'Nama Kategori',
                hint: 'Contoh: Makanan, Minuman, dll',
                controller: _namaController,
                validator: (value) => Validators.required(value, fieldName: 'Nama kategori'),
                prefixIcon: const Icon(Icons.category_outlined),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Deskripsi (Opsional)',
                hint: 'Deskripsi kategori',
                controller: _deskripsiController,
                maxLines: 3,
                prefixIcon: const Icon(Icons.description_outlined),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 32),
              
              Consumer<KategoriProvider>(
                builder: (context, kategoriProvider, _) {
                  return CustomButton(
                    text: isEdit ? 'Update' : 'Simpan',
                    onPressed: _handleSubmit,
                    isLoading: kategoriProvider.isLoading,
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
