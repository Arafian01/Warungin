import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'dashboard/dashboard_page.dart';
import 'kategori/kategori_list_page.dart';
import 'barang/barang_list_page.dart';
// import 'transaksi/transaksi_page.dart'; // DISABLED
// import 'riwayat/riwayat_page.dart'; // DISABLED

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    KategoriListPage(),
    BarangListPage(),
    // TransaksiPage(), // DISABLED
    // RiwayatPage(), // DISABLED
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.bodySmall,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: AppStrings.dashboard,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: AppStrings.kategori,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: AppStrings.barang,
          ),
          // DISABLED - Transaksi features
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.shopping_cart_outlined),
          //   activeIcon: Icon(Icons.shopping_cart),
          //   label: AppStrings.transaksi,
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.history_outlined),
          //   activeIcon: Icon(Icons.history),
          //   label: AppStrings.riwayat,
          // ),
        ],
      ),
    );
  }
}
