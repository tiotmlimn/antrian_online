import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/floating_app_bar.dart';
import '../../widgets/custom_bottom_nav.dart';
import 'user_beranda_tab.dart';
import 'user_layanan_tab.dart';
import 'user_riwayat_tab.dart';
import 'user_profil_tab.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _currentIndex = 0;

  static const _titles = ['Beranda', 'Layanan', 'Riwayat', 'Profil'];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isLoggedIn) return const SizedBox();
    return Container(
      decoration: AppTheme.blurredBackground(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: _buildDrawer(context),
        body: SafeArea(
          child: Column(
            children: [
              FloatingAppBar(
                title: _titles[_currentIndex],
                isDark: true,
                leading: Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu_rounded, color: Colors.white),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: const [
                    UserBerandaTab(),
                    UserLayananTab(),
                    UserRiwayatTab(),
                    UserProfilTab(),
                  ],
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar: CustomBottomNav(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return AppDrawer(
      currentRoute: '',
      items: [
        DrawerItem(title: 'Pengaturan', icon: Icons.settings_rounded, route: '', onTap: () {}),
        DrawerItem(title: 'Lapor Bug', icon: Icons.bug_report_rounded, route: '', onTap: () {}),
        DrawerItem(title: 'Syarat & Ketentuan', icon: Icons.description_rounded, route: '', onTap: () {}),
        DrawerItem(title: 'Rating', icon: Icons.star_rounded, route: '', onTap: () {}),
      ],
    );
  }
}
