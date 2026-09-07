import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class MainWrapperScreen extends StatefulWidget {
  const MainWrapperScreen({super.key});

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int _bottomNavIndex = 0;

  // قائمة الأيقونات الخاصة بالشريط السفلي
  final List<IconData> _iconList = [
    Icons.home_rounded,
    Icons.grid_view_rounded,
    Icons.shopping_bag_outlined,
    Icons.person_outline_rounded,
  ];

  // قائمة الشاشات المرتبطة بكل Tab
  final List<Widget> _screens = const [
    Center(child: Text('الرئيسية / Catalog')),
    Center(child: Text('الأقسام / Categories')),
    Center(child: Text('السلة وعروض الأسعار / Cart & Quotes')),
    Center(child: Text('الحساب الشخصي / Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _bottomNavIndex,
        children: _screens,
      ),

      // الزر الأوسط العائم (Docked FAB)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // إجراء البحث السريع أو فتح الكاميرا/الماسح الضوئي
        },
        backgroundColor: AppColors.primaryCyan,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // شريط التنقل السفلي المتحرك بأنيميشن Drop
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: _iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        leftCornerRadius: 20,
        rightCornerRadius: 20,
        backgroundColor: AppColors.deepPurple,
        activeColor: AppColors.primaryCyan,
        inactiveColor: Colors.white60,
        iconSize: 26,
        
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}