import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/auth_provider.dart' as auth_provider;
import '../../providers/transaksi_provider.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_card.dart';
import '../auth/login_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appName,
              style: AppTextStyles.heading3.copyWith(color: Colors.white),
            ),
            Text(
              'Halo, ${user?.displayName ?? 'User'}',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final confirm = await Helpers.showConfirmDialog(
                context,
                title: 'Logout',
                message: 'Apakah Anda yakin ingin keluar?',
              );
              
              if (confirm && context.mounted) {
                await Provider.of<auth_provider.AuthProvider>(context, listen: false).signOut();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            _buildSummarySection(context),
            const SizedBox(height: AppDimensions.marginLarge),
            
            // Quick Actions
            Text(
              'Menu Cepat',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: AppDimensions.marginMedium),
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    final transaksiProvider = Provider.of<TransaksiProvider>(context);
    final today = Helpers.getTodayRange();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ringkasan Hari Ini',
          style: AppTextStyles.heading3,
        ),
        const SizedBox(height: AppDimensions.marginMedium),
        
        FutureBuilder<double>(
          future: transaksiProvider.getTotalPenjualan(today.start, today.end),
          builder: (context, snapshot) {
            final total = snapshot.data ?? 0;
            
            return CustomCard(
              color: AppColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.attach_money,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Penjualan',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              Formatters.currency(total),
                              style: AppTextStyles.heading2.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    Formatters.date(DateTime.now()),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppDimensions.marginMedium,
      crossAxisSpacing: AppDimensions.marginMedium,
      children: [
        _buildActionCard(
          icon: Icons.category,
          title: 'Kategori',
          subtitle: 'Kelola kategori',
          color: Colors.blue,
          onTap: () {
            // Navigate handled by bottom nav
          },
        ),
        _buildActionCard(
          icon: Icons.inventory_2,
          title: 'Barang',
          subtitle: 'Kelola barang',
          color: Colors.green,
          onTap: () {
            // Navigate handled by bottom nav
          },
        ),
        _buildActionCard(
          icon: Icons.shopping_cart,
          title: 'Transaksi',
          subtitle: 'Buat transaksi',
          color: Colors.orange,
          onTap: () {
            // Navigate handled by bottom nav
          },
        ),
        _buildActionCard(
          icon: Icons.history,
          title: 'Riwayat',
          subtitle: 'Lihat riwayat',
          color: Colors.purple,
          onTap: () {
            // Navigate handled by bottom nav
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 40,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
