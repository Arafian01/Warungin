# ✅ Database Structure Updated

## 📊 Struktur Database Baru

### Collections & Fields:

#### 1. **barang**
```
users/{userId}/barang/{barangId}
- id: string (auto-generated)
- id_kategori: string
- nama_barang: string
- created_at: timestamp
```

#### 2. **barang_satuan**
```
users/{userId}/barang_satuan/{satuanId}
- id: string (auto-generated)
- id_barang: string (reference ke barang)
- nama_satuan: string (pcs, dus, karton, dll)
- harga_jual: number
- created_at: timestamp
```

#### 3. **transaksi**
```
users/{userId}/transaksi/{transaksiId}
- id: string (auto-generated)
- total_harga: number
- tanggal: timestamp
- catatan: string (optional)
- created_at: timestamp
```

#### 4. **detail_transaksi**
```
users/{userId}/detail_transaksi/{detailId}
- id: string (auto-generated)
- id_transaksi: string (reference ke transaksi)
- id_barang_satuan: string (reference ke barang_satuan)
- id_barang: string (reference ke barang)
- nama_barang: string
- jumlah: number
- created_at: timestamp
```

## ✅ Models yang Sudah Diupdate

### 1. BarangModel ✅
**Fields:**
- `id` (String?)
- `idKategori` (String)
- `namaBarang` (String)
- `createdAt` (DateTime?)

**Removed:** `harga`, `satuan` (pindah ke BarangSatuanModel)

### 2. BarangSatuanModel ✅
**Fields:**
- `id` (String?)
- `idBarang` (String)
- `namaSatuan` (String)
- `hargaJual` (double)
- `createdAt` (DateTime?)

**Status:** Model sudah ada dan siap digunakan

### 3. TransaksiModel ✅
**Fields:**
- `id` (String?)
- `totalHarga` (double)
- `tanggal` (DateTime)
- `catatan` (String?)
- `createdAt` (DateTime?)

**Removed:** `metode` (tidak diperlukan untuk saat ini)

### 4. DetailTransaksiModel ✅
**Fields:**
- `id` (String?)
- `idTransaksi` (String)
- `idBarangSatuan` (String) - NEW
- `idBarang` (String)
- `namaBarang` (String)
- `jumlah` (int)
- `createdAt` (DateTime?)

**Removed:** `hargaSatuan`, `subtotal` (akan dihitung dari join dengan barang_satuan)

## ⚠️ Breaking Changes

Aplikasi saat ini **TIDAK BISA BERJALAN** karena perlu update di:

### Services yang Perlu Diupdate:
1. ✅ `BarangService` - Sudah ada, perlu minor update
2. ❌ `BarangSatuanService` - **PERLU DIBUAT BARU**
3. ❌ `TransaksiService` - **PERLU UPDATE BESAR**

### Providers yang Perlu Diupdate:
1. ❌ `BarangProvider` - Update untuk remove harga/satuan
2. ❌ `BarangSatuanProvider` - **PERLU DIBUAT BARU**
3. ❌ `TransaksiProvider` - Update untuk struktur baru
4. ❌ `CartProvider` - **PERLU REDESIGN** (gunakan BarangSatuanModel)

### UI Pages yang Perlu Diupdate:
1. ❌ `barang_form_page.dart` - Remove harga/satuan fields
2. ❌ `barang_list_page.dart` - Show barang without price
3. ❌ `transaksi_page.dart` - Update untuk gunakan barang_satuan
4. ❌ `select_barang_page.dart` - Select barang_satuan instead of barang
5. ❌ `detail_transaksi_page.dart` - Update display logic
6. ❌ `riwayat_page.dart` - Update untuk field baru

### Widgets yang Perlu Diupdate:
1. ❌ `barang_card.dart` - Remove harga/satuan display
2. ❌ `cart_item_card.dart` - Update untuk barang_satuan
3. ❌ `transaksi_card.dart` - Update field names

## 🔧 Langkah Implementasi

Karena ini adalah perubahan besar, saya sarankan pendekatan bertahap:

### Phase 1: Core Services & Providers
1. Create `BarangSatuanService`
2. Create `BarangSatuanProvider`
3. Update `TransaksiService`
4. Redesign `CartProvider`

### Phase 2: Barang Management
1. Update `barang_form_page.dart` - Hanya input nama barang
2. Create `barang_satuan_form_page.dart` - Input satuan & harga
3. Update `barang_list_page.dart` - Show list barang dengan tombol "Kelola Satuan"
4. Create `barang_satuan_list_page.dart` - Show satuan per barang

### Phase 3: Transaction System
1. Update `select_barang_page.dart` - Select dari barang_satuan
2. Update `transaksi_page.dart` - Cart menggunakan barang_satuan
3. Update `TransaksiProvider.createTransaksi()`
4. Update `detail_transaksi_page.dart` - Join data dari barang_satuan

### Phase 4: UI Polish
1. Update all widgets
2. Update dashboard
3. Test all flows

## 💡 Rekomendasi

**PENTING:** Ini adalah perubahan arsitektur yang signifikan. Estimasi waktu: **8-12 jam kerja**.

### Opsi 1: Implementasi Penuh (Recommended jika butuh fitur lengkap)
- Implementasi semua phase di atas
- Aplikasi akan lebih scalable
- Support multiple pricing per item

### Opsi 2: Revert ke Struktur Lama (Recommended untuk MVP cepat)
- Kembalikan models ke versi sebelumnya
- Aplikasi langsung bisa jalan
- Cukup untuk use case sederhana

## 📝 Contoh Use Case dengan Struktur Baru

### Skenario: Toko Kelontong

**1. Tambah Barang:**
```
Nama: Indomie Goreng
Kategori: Makanan
```

**2. Tambah Satuan untuk Barang:**
```
Barang: Indomie Goreng
Satuan: pcs, Harga: Rp 3.000

Barang: Indomie Goreng
Satuan: dus, Harga: Rp 110.000

Barang: Indomie Goreng
Satuan: karton, Harga: Rp 525.000
```

**3. Transaksi:**
```
- Pilih: Indomie Goreng (pcs) × 5
- Pilih: Indomie Goreng (dus) × 2
Total: Rp 235.000
```

**4. Data Tersimpan:**

`barang`:
```json
{
  "id": "brg001",
  "id_kategori": "kat001",
  "nama_barang": "Indomie Goreng"
}
```

`barang_satuan`:
```json
[
  {
    "id": "sat001",
    "id_barang": "brg001",
    "nama_satuan": "pcs",
    "harga_jual": 3000
  },
  {
    "id": "sat002",
    "id_barang": "brg001",
    "nama_satuan": "dus",
    "harga_jual": 110000
  }
]
```

`transaksi`:
```json
{
  "id": "trx001",
  "total_harga": 235000,
  "tanggal": "2023-10-20T14:30:00",
  "catatan": null
}
```

`detail_transaksi`:
```json
[
  {
    "id": "det001",
    "id_transaksi": "trx001",
    "id_barang_satuan": "sat001",
    "id_barang": "brg001",
    "nama_barang": "Indomie Goreng",
    "jumlah": 5
  },
  {
    "id": "det002",
    "id_transaksi": "trx001",
    "id_barang_satuan": "sat002",
    "id_barang": "brg001",
    "nama_barang": "Indomie Goreng",
    "jumlah": 2
  }
]
```

## 🚀 Next Steps

**Pilih salah satu:**

### A. Lanjutkan Implementasi
Saya akan mulai membuat services dan providers baru. Estimasi: 8-12 jam.

### B. Revert ke Struktur Lama
Kembalikan models agar aplikasi bisa langsung jalan. Estimasi: 30 menit.

---

**Status:** ⚠️ Models Updated - Services & UI Need Updates

Silakan beritahu pilihan Anda!
