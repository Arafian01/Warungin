import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/constants.dart';
import '../services/local_storage_service.dart';
import 'auth/login_page.dart';
import 'main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndData();
  }

  Future<void> _checkAuthAndData() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Get local storage instance
    final localStorage = await LocalStorageService.getInstance();
    final hasLocalData = localStorage.hasData();
    final user = FirebaseAuth.instance.currentUser;
    
    // If user is logged in OR has cached data, go to MainPage
    if (user != null || hasLocalData) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } else {
      // No user and no cached data, go to LoginPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo/Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.store,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            
            // App Name
            Text(
              AppStrings.appName,
              style: AppTextStyles.heading1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Tagline
            Text(
              AppStrings.appTagline,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 48),
            
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
