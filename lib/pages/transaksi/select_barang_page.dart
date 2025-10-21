import 'package:flutter/material.dart';
import 'select_barang_satuan_page.dart';

class SelectBarangPage extends StatelessWidget {
  const SelectBarangPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Redirect to SelectBarangSatuanPage since cart works with BarangSatuan
    return const SelectBarangSatuanPage();
  }
}
