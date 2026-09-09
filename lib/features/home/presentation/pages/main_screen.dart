import 'package:flutter/material.dart';
import 'package:taamol_tech/core/constants/app_colors.dart';
import 'package:taamol_tech/core/constants/app_strings.dart';
import 'package:taamol_tech/features/products/presentation/pages/contact_us_screen.dart';
import 'package:taamol_tech/features/home/presentation/pages/home_screen.dart';
import 'package:taamol_tech/features/products/presentation/pages/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ContactUsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primaryCyan,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.grid_view_outlined),
            activeIcon: const Icon(Icons.grid_view),
            label: AppStrings.tr(context, AppStrings.products),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.support_agent_outlined),
            activeIcon: const Icon(Icons.support_agent),
            label: AppStrings.tr(context, AppStrings.contactUs),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: AppStrings.tr(context, AppStrings.profile),
          ),
        ],
      ),
    );
  }
}
