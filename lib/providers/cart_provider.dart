import 'package:flutter/material.dart';
import '../models/barang_model.dart';
import '../models/barang_satuan_model.dart';

class CartItem {
  final BarangSatuanModel barangSatuan;
  final BarangModel barang;
  int jumlah;

  CartItem({
    required this.barangSatuan,
    required this.barang,
    required this.jumlah,
  });

  double get subtotal => barangSatuan.hargaJual * jumlah;
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  
  int get itemCount => _items.length;
  
  double get totalAmount {
    double total = 0;
    for (var item in _items) {
      total += item.subtotal;
    }
    return total;
  }

  // Add item to cart
  void addItem(BarangSatuanModel barangSatuan, BarangModel barang, int jumlah) {
    // Check if item already exists (by barang satuan ID)
    int existingIndex = _items.indexWhere((item) => item.barangSatuan.id == barangSatuan.id);
    
    if (existingIndex >= 0) {
      // Update quantity
      _items[existingIndex].jumlah += jumlah;
    } else {
      // Add new item
      _items.add(CartItem(
        barangSatuan: barangSatuan,
        barang: barang,
        jumlah: jumlah,
      ));
    }
    
    notifyListeners();
  }

  // Update item quantity
  void updateItemQuantity(String barangSatuanId, int newJumlah) {
    int index = _items.indexWhere((item) => item.barangSatuan.id == barangSatuanId);
    
    if (index >= 0) {
      if (newJumlah > 0) {
        _items[index].jumlah = newJumlah;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Remove item from cart
  void removeItem(String barangSatuanId) {
    _items.removeWhere((item) => item.barangSatuan.id == barangSatuanId);
    notifyListeners();
  }

  // Clear cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Check if item exists in cart
  bool isInCart(String barangSatuanId) {
    return _items.any((item) => item.barangSatuan.id == barangSatuanId);
  }

  // Get item quantity
  int getItemQuantity(String barangSatuanId) {
    int index = _items.indexWhere((item) => item.barangSatuan.id == barangSatuanId);
    return index >= 0 ? _items[index].jumlah : 0;
  }
}
