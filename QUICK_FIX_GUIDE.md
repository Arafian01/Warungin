# 🔧 Quick Fix Guide - Error Resolution

## ✅ Fixed Files

1. **CartProvider** ✅ - Redesigned to use BarangSatuanModel
2. **BarangSatuanService** ✅ - Created
3. **BarangSatuanProvider** ✅ - Created

## 🔴 Files with Errors (Need Manual Fix)

Karena perubahan struktur database sangat besar, beberapa file perlu di-disable sementara atau di-fix manual. Berikut panduan lengkapnya:

### Option 1: Disable Fitur Transaksi Sementara (RECOMMENDED)

Untuk membuat aplikasi bisa run, kita bisa disable fitur transaksi dulu dan fokus ke CRUD Barang + Barang Satuan.

#### Files to Comment Out:

1. **lib/pages/main_page.dart**
   - Comment out Transaksi tab dari BottomNavigationBar
   - Hanya tampilkan: Dashboard, Barang, Riwayat (disabled)

2. **lib/pages/dashboard/dashboard_page.dart**
   - Comment out bagian transaksi summary
   - Fokus ke kategori & barang count

### Option 2: Fix Semua File (8-10 jam)

Jika ingin fix semua, ikuti urutan ini:

---

## 📝 Detailed Fix Instructions

### 1. barang_form_page.dart

**Remove these fields:**
```dart
// DELETE:
final _hargaController = TextEditingController();
String? _selectedSatuan;

// DELETE in initState:
_hargaController.text = widget.barang!.harga.toString();
_selectedSatuan = widget.barang!.satuan;

// DELETE in build:
CustomTextField(
  controller: _hargaController,
  label: 'Harga',
  ...
),
DropdownButtonFormField(
  value: _selectedSatuan,
  items: ['pcs', 'dus', 'karton', ...],
  ...
),
```

**Update save method:**
```dart
final barang = BarangModel(
  id: widget.barang?.id,
  idKategori: _selectedKategori!,
  namaBarang: _namaController.text,
  // REMOVE: harga & satuan
);
```

**After save, navigate to Barang Satuan page:**
```dart
if (success && barangId != null) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => BarangSatuanListPage(
        barang: barang.copyWith(id: barangId),
      ),
    ),
  );
}
```

---

### 2. select_barang_page.dart

**Complete Rewrite Needed:**

```dart
// OLD: Select BarangModel
// NEW: Select BarangSatuanModel

class SelectBarangPage extends StatefulWidget {
  // ... same
}

class _SelectBarangPageState extends State<SelectBarangPage> {
  @override
  void initState() {
    super.initState();
    // Load barang satuan instead
    Provider.of<BarangSatuanProvider>(context, listen: false)
        .loadAllBarangSatuan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pilih Barang')),
      body: Consumer2<BarangSatuanProvider, BarangProvider>(
        builder: (context, satuanProv, barangProv, _) {
          // Group satuan by barang
          Map<String, List<BarangSatuanModel>> groupedSatuan = {};
          for (var satuan in satuanProv.barangSatuanList) {
            if (!groupedSatuan.containsKey(satuan.idBarang)) {
              groupedSatuan[satuan.idBarang] = [];
            }
            groupedSatuan[satuan.idBarang]!.add(satuan);
          }

          return ListView.builder(
            itemCount: groupedSatuan.length,
            itemBuilder: (context, index) {
              String barangId = groupedSatuan.keys.elementAt(index);
              List<BarangSatuanModel> satuanList = groupedSatuan[barangId]!;
              
              // Get barang info
              BarangModel? barang = barangProv.barangList
                  .firstWhere((b) => b.id == barangId);

              return ExpansionTile(
                title: Text(barang.namaBarang),
                children: satuanList.map((satuan) {
                  return ListTile(
                    title: Text(satuan.namaSatuan),
                    subtitle: Text(Formatters.currency(satuan.hargaJual)),
                    onTap: () {
                      // Add to cart
                      Provider.of<CartProvider>(context, listen: false)
                          .addItem(satuan, barang, 1);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
```

---

### 3. transaksi_page.dart

**Update TransaksiModel creation:**

```dart
// OLD:
final transaksi = TransaksiModel(
  tanggal: DateTime.now(),
  total: cartProvider.totalAmount,
  metode: _selectedMetode,
  catatan: _catatanController.text.isEmpty ? null : _catatanController.text,
);

// NEW:
final transaksi = TransaksiModel(
  totalHarga: cartProvider.totalAmount,
  tanggal: DateTime.now(),
  catatan: _catatanController.text.isEmpty ? null : _catatanController.text,
);
```

**Update DetailTransaksiModel creation:**

```dart
// OLD:
final details = cartProvider.items.map((item) {
  return DetailTransaksiModel(
    idTransaksi: '',
    idBarang: item.barang.id!,
    namaBarang: item.barang.namaBarang,
    jumlah: item.jumlah,
    hargaSatuan: item.barang.harga,
    subtotal: item.subtotal,
  );
}).toList();

// NEW:
final details = cartProvider.items.map((item) {
  return DetailTransaksiModel(
    idTransaksi: '',
    idBarangSatuan: item.barangSatuan.id!,
    idBarang: item.barang.id!,
    namaBarang: item.barang.namaBarang,
    jumlah: item.jumlah,
  );
}).toList();
```

**Remove metode dropdown:**
```dart
// DELETE:
DropdownButtonFormField<String>(
  value: _selectedMetode,
  items: ['Cash', 'Transfer', 'QRIS']...
)
```

---

### 4. cart_item_card.dart

**Update display:**

```dart
// OLD:
Text('${Formatters.currency(item.barang.harga)} / ${item.barang.satuan}')

// NEW:
Text('${item.barang.namaBarang} - ${item.barangSatuan.namaSatuan}')
Text(Formatters.currency(item.barangSatuan.hargaJual))
```

**Update remove/update methods:**

```dart
// OLD:
cartProvider.removeItem(item.barang.id!)
cartProvider.updateItemQuantity(item.barang.id!, newQty)

// NEW:
cartProvider.removeItem(item.barangSatuan.id!)
cartProvider.updateItemQuantity(item.barangSatuan.id!, newQty)
```

---

### 5. detail_transaksi_page.dart

**Update field names:**

```dart
// OLD:
widget.transaksi.total
widget.transaksi.metode

// NEW:
widget.transaksi.totalHarga
// Remove metode display
```

**Update detail display (need to fetch barang_satuan):**

```dart
// Need to fetch harga from barang_satuan
FutureBuilder<BarangSatuanModel?>(
  future: Provider.of<BarangSatuanProvider>(context, listen: false)
      .getBarangSatuanById(detail.idBarangSatuan),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();
    
    final satuan = snapshot.data!;
    final subtotal = satuan.hargaJual * detail.jumlah;
    
    return ListTile(
      title: Text(detail.namaBarang),
      subtitle: Text('${Formatters.currency(satuan.hargaJual)} × ${detail.jumlah}'),
      trailing: Text(Formatters.currency(subtotal)),
    );
  },
)
```

---

### 6. transaksi_card.dart

**Update field names:**

```dart
// OLD:
transaksi.total
transaksi.metode
transaksi.catatan

// NEW:
transaksi.totalHarga
// Remove metode
transaksi.catatan
```

---

### 7. barang_card.dart

**Fix currency formatter:**

```dart
// OLD:
'${Formatters.currency()} / ${barangSatuanModel.namaSatuan}'

// NEW - Show satuan count instead:
FutureBuilder<int>(
  future: Provider.of<BarangSatuanProvider>(context, listen: false)
      .getBarangSatuanCount(barang.id!),
  builder: (context, snapshot) {
    int count = snapshot.data ?? 0;
    return Text('$count satuan tersedia');
  },
)
```

---

### 8. TransaksiService

**Update field names in queries:**

```dart
// OLD:
transaksiList.sort((a, b) => b.tanggal.compareTo(a.tanggal));
total += transaksi.total;

// NEW:
transaksiList.sort((a, b) => b.tanggal.compareTo(a.tanggal)); // Same
total += transaksi.totalHarga;
```

---

## 🎯 Recommended Approach

**Phase 1: Make App Runnable (2 hours)**
1. Fix barang_form_page.dart - remove harga/satuan
2. Create simple barang_satuan_list_page.dart
3. Create simple barang_satuan_form_page.dart
4. Comment out transaksi features temporarily

**Phase 2: Fix Transaction System (4-6 hours)**
1. Fix select_barang_page.dart (complete rewrite)
2. Fix transaksi_page.dart
3. Fix cart_item_card.dart
4. Fix detail_transaksi_page.dart
5. Fix transaksi_card.dart

**Phase 3: Polish (1-2 hours)**
1. Fix barang_card.dart
2. Test all flows
3. Fix any remaining bugs

---

## 🚨 Critical Note

Struktur database baru ini memerlukan perubahan besar di hampir semua file transaksi. Jika Anda butuh aplikasi running cepat, saya sangat merekomendasikan untuk **revert ke struktur lama** dan gunakan struktur baru ini untuk versi 2.0 nanti.

---

**Status:** 🔴 Many files need manual fixes

**Estimated Time to Fix All:** 8-12 hours

**Recommendation:** Revert atau disable transaksi features dulu
