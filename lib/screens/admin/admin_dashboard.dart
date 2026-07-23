import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/queue_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/floating_app_bar.dart';
import 'admin_manage_users.dart';
import 'admin_manage_poly.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isLoggedIn) return const SizedBox();
    final queueProv = context.watch<QueueProvider>();
    final user = auth.currentUser!;

    return Scaffold(
      drawer: AppDrawer(
        currentRoute: '/',
        items: [
          DrawerItem(title: 'Dashboard', icon: Icons.dashboard_rounded, route: '/', onTap: () {}),
          DrawerItem(title: 'Kelola User', icon: Icons.people_rounded, route: '/users', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminManageUsers()));
          }),
          DrawerItem(title: 'Kelola Poli', icon: Icons.medical_services_rounded, route: '/poly', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminManagePoly()));
          }),
        ],
      ),
      body: Container(
        decoration: AppTheme.blurredBackground(),
        child: SafeArea(
          child: Column(
            children: [
              FloatingAppBar(
                title: 'Dashboard',
                leading: Builder(
                  builder: (ctx) => IconButton(
                    icon: Icon(Icons.menu_rounded, color: AppTheme.darkText),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppTheme.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCampusCard(user.name),
                      const SizedBox(height: 20),
                      _buildStatsGrid(queueProv),
                      const SizedBox(height: 20),
                      _buildQuickActions(context),
                      const SizedBox(height: 20),
                      _buildTodaySummary(queueProv),
                      const SizedBox(height: 20),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampusCard(String name) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryIndigo.withValues(alpha: 0.12), AppTheme.primaryPurple.withValues(alpha: 0.06)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(color: AppTheme.primaryIndigo.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 6)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  gradient: AppTheme.indigoGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: AppTheme.primaryIndigo.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.badge_outlined, size: 13, color: AppTheme.lightText),
                        const SizedBox(width: 4),
                        Text('Administrator', style: TextStyle(fontSize: 12, color: AppTheme.lightText)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primaryIndigo.withValues(alpha: 0.2), AppTheme.primaryPurple.withValues(alpha: 0.15)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on_rounded, size: 11, color: AppTheme.primaryIndigo),
                          const SizedBox(width: 3),
                          Text('Universitas Pamulang', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryIndigo)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Text('HealthCampus v1.0 • Universitas Pamulang',
        style: TextStyle(fontSize: 11, color: AppTheme.lightText.withValues(alpha: 0.5))),
    );
  }

  Widget _buildStatsGrid(QueueProvider queueProv) {
    return Row(
      children: [
        Expanded(child: _statCard('Total', '${queueProv.todayTotal}', Icons.people_alt, AppTheme.primaryBlue)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Selesai', '${queueProv.todayCompleted}', Icons.check_circle, Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Poli', '${queueProv.polis.length}', Icons.medical_services, AppTheme.primaryPurple)),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: AppTheme.lightText, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryIndigo.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.flash_on_rounded, color: AppTheme.primaryIndigo, size: 18),
            ),
            const SizedBox(width: 10),
            Text('Aksi Cepat', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _actionCard(
              icon: Icons.people_outline,
              label: 'Kelola User',
              color: AppTheme.primaryBlue,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminManageUsers())),
            )),
            const SizedBox(width: 12),
            Expanded(child: _actionCard(
              icon: Icons.local_hospital,
              label: 'Kelola Poli',
              color: AppTheme.primaryPurple,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminManagePoly())),
            )),
          ],
        ),
      ],
    );
  }

  Widget _actionCard({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 28),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 14),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.darkText)),
        ],
      ),
    );
  }

  Widget _buildTodaySummary(QueueProvider queueProv) {
    final todayQueues = queueProv.queues.where((q) =>
      q.createdAt.year == DateTime.now().year &&
      q.createdAt.month == DateTime.now().month &&
      q.createdAt.day == DateTime.now().day
    ).toList();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.bar_chart_rounded, color: AppTheme.primaryBlue, size: 18),
              ),
              const SizedBox(width: 10),
              Text('Ringkasan Hari Ini', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
            ],
          ),
          const SizedBox(height: 16),
          ...queueProv.polis.map((poly) {
            final count = todayQueues.where((q) => q.polyId == poly.id).length;
            final maxCount = queueProv.polis.isEmpty ? 1 : todayQueues.length;
            final fraction = maxCount > 0 ? count / (todayQueues.isNotEmpty ? todayQueues.length : 1) : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(poly.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.darkText)),
                      Text('$count antrean', style: TextStyle(fontSize: 12, color: AppTheme.lightText)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: fraction,
                      backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        count > 5 ? AppTheme.primaryIndigo : AppTheme.primaryBlue,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
