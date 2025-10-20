# 🔄 Database Structure Migration

## Perubahan Struktur Database

Struktur database telah diupdate untuk memisahkan informasi harga dan satuan dari barang utama.

### ❌ Struktur Lama

```
kategori: { nama_kategori, deskripsi }
barang: { id_kategori, nama_barang, harga, satuan }
transaksi: { tanggal, total, metode, catatan }
detail_transaksi: { id_transaksi, id_barang, nama_barang, jumlah, harga_satuan, subtotal }
```

### ✅ Struktur Baru

```
kategori: { nama_kategori, deskripsi }
barang: { id_kategori, kode_barang, nama_barang }
barang_satuan: { id_barang, nama_satuan, harga_jual }
transaksi: { kode_transaksi, tanggal_transaksi, total_harga }
detail_transaksi: { id_transaksi, id_barang_satuan, jumlah }
```

## 📊 Perubahan Detail

### 1. Tabel `barang`
**Perubahan:**
- ✅ **Ditambahkan**: `kode_barang` (String) - Kode unik barang
- ❌ **Dihapus**: `harga` (double) - Pindah ke `barang_satuan`
- ❌ **Dihapus**: `satuan` (String) - Pindah ke `barang_satuan`

**Alasan**: Satu barang bisa memiliki multiple satuan dengan harga berbeda (contoh: Indomie bisa dijual per pcs atau per dus)

### 2. Tabel `barang_satuan` (BARU)
**Fields:**
- `id` (String) - Auto-generated ID
- `id_barang` (String) - Reference ke tabel barang
- `nama_satuan` (String) - Nama satuan (pcs, dus, karton, dll)
- `harga_jual` (double) - Harga jual untuk satuan ini
- `created_at` (Timestamp)

**Contoh Data:**
```json
// Barang: Indomie Goreng
{
  "id_barang": "barang_001",
  "nama_satuan": "pcs",
  "harga_jual": 3000
}
{
  "id_barang": "barang_001",
  "nama_satuan": "dus",
  "harga_jual": 72000
}
```

### 3. Tabel `transaksi`
**Perubahan:**
- ✅ **Ditambahkan**: `kode_transaksi` (String) - Kode unik transaksi (contoh: TRX20231020001)
- 🔄 **Diubah**: `tanggal` → `tanggal_transaksi`
- 🔄 **Diubah**: `total` → `total_harga`
- ❌ **Dihapus**: `metode` (String) - Metode pembayaran
- ❌ **Dihapus**: `catatan` (String) - Catatan transaksi

**Alasan**: Fokus pada data transaksi inti, metode pembayaran dan catatan bisa ditambahkan nanti jika diperlukan

### 4. Tabel `detail_transaksi`
**Perubahan:**
- 🔄 **Diubah**: `id_barang` → `id_barang_satuan` (Reference ke `barang_satuan` bukan `barang`)
- ❌ **Dihapus**: `nama_barang` (String) - Bisa di-join dari `barang`
- ❌ **Dihapus**: `harga_satuan` (double) - Bisa di-join dari `barang_satuan`
- ❌ **Dihapus**: `subtotal` (double) - Bisa dihitung: `jumlah × harga_jual`

**Alasan**: Normalisasi database, menghindari redundansi data

## 🔧 Status Implementasi

### ✅ Selesai
- [x] Model `BarangModel` updated
- [x] Model `BarangSatuanModel` created
- [x] Model `TransaksiModel` updated
- [x] Model `DetailTransaksiModel` updated

### ⏳ Perlu Diupdate
- [ ] Service `BarangService` - Update CRUD untuk struktur baru
- [ ] Service `BarangSatuanService` - Create new service
- [ ] Service `TransaksiService` - Update untuk menggunakan `barang_satuan`
- [ ] Provider `BarangProvider` - Update state management
- [ ] Provider `BarangSatuanProvider` - Create new provider
- [ ] Provider `TransaksiProvider` - Update state management
- [ ] Provider `CartProvider` - Update untuk menggunakan `BarangSatuanModel`
- [ ] UI Pages - Update semua pages yang menggunakan model lama
- [ ] Widgets - Update semua widgets yang menggunakan model lama

## 📝 Catatan Penting

### Untuk Developer

**PERHATIAN**: Perubahan ini akan menyebabkan breaking changes pada:
1. Semua pages yang menggunakan `BarangModel` (harga & satuan)
2. Semua pages yang menggunakan `TransaksiModel` (metode & catatan)
3. Semua pages yang menggunakan `DetailTransaksiModel`
4. Cart system yang menyimpan harga di `BarangModel`

### Langkah Migrasi

1. **Backup data lama** (jika ada data di Firestore)
2. **Update semua services** untuk menggunakan struktur baru
3. **Update semua providers** untuk state management
4. **Update semua UI pages** dan widgets
5. **Test thoroughly** sebelum deploy

### Data Migration Script

Jika sudah ada data di production, perlu migration script untuk:
1. Membuat collection `barang_satuan` dari data `barang` yang ada
2. Update `detail_transaksi` untuk menggunakan `id_barang_satuan`
3. Update `transaksi` dengan `kode_transaksi` dan field names baru

## 🚀 Keuntungan Struktur Baru

1. **Flexible Pricing**: Satu barang bisa punya multiple harga untuk satuan berbeda
2. **Better Normalization**: Mengurangi redundansi data
3. **Scalable**: Mudah menambah satuan baru tanpa mengubah struktur barang
4. **Cleaner Data**: Transaksi hanya menyimpan reference, bukan duplicate data

## 📖 Contoh Use Case

### Skenario: Toko Kelontong

**Barang**: Indomie Goreng
- Kode: `BRG001`
- Kategori: Makanan

**Satuan & Harga**:
- 1 pcs = Rp 3.000
- 1 dus (isi 40) = Rp 110.000
- 1 karton (isi 5 dus) = Rp 525.000

**Transaksi**:
```
Kode: TRX20231020001
Tanggal: 2023-10-20 14:30
Items:
  - Indomie Goreng (pcs) × 5 = Rp 15.000
  - Indomie Goreng (dus) × 2 = Rp 220.000
Total: Rp 235.000
```

Dengan struktur baru, ini mudah diimplementasikan karena setiap satuan punya ID sendiri.

## ⚠️ Breaking Changes

Aplikasi saat ini **TIDAK AKAN BERJALAN** sampai semua services, providers, dan UI diupdate.

Error yang akan muncul:
- `The getter 'harga' isn't defined for the type 'BarangModel'`
- `The getter 'satuan' isn't defined for the type 'BarangModel'`
- `The getter 'metode' isn't defined for the type 'TransaksiModel'`
- `The getter 'catatan' isn't defined for the type 'TransaksiModel'`
- Dan banyak error lainnya...

## 🔄 Next Steps

1. **Putuskan**: Apakah ingin melanjutkan dengan struktur baru atau revert ke struktur lama?
2. **Jika lanjut**: Perlu update semua services, providers, dan UI (estimasi 4-6 jam kerja)
3. **Jika revert**: Kembalikan models ke versi sebelumnya

## 💡 Rekomendasi

Untuk aplikasi kasir sederhana, **struktur lama mungkin lebih cocok** karena:
- Lebih simple
- Lebih cepat development
- Cukup untuk use case dasar

Struktur baru cocok jika:
- Perlu multiple pricing per barang
- Perlu sistem yang lebih scalable
- Ada rencana fitur advanced (grosir, diskon per satuan, dll)

---

**Status**: ⚠️ Migration In Progress - App Currently Broken

Untuk melanjutkan development, pilih salah satu:
1. Complete migration (update all services & UI)
2. Revert to old structure
