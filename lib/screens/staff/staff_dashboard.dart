import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../models/queue_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/queue_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_button.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/floating_app_bar.dart';
import 'staff_manage.dart';

class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

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
          DrawerItem(title: 'Kelola Antrean', icon: Icons.queue_rounded, route: '/manage', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffManageQueue()));
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
                      _buildStatsRow(queueProv),
                      const SizedBox(height: 20),
                      _buildCurrentCalling(context, queueProv),
                      const SizedBox(height: 20),
                      _buildRecentQueue(context, queueProv),
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
              colors: [AppTheme.primaryPurple.withValues(alpha: 0.12), AppTheme.primaryIndigo.withValues(alpha: 0.06)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(color: AppTheme.primaryPurple.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 6)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  gradient: AppTheme.purpleGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: AppTheme.primaryPurple.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 28),
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
                        Text('Staff Kesehatan', style: TextStyle(fontSize: 12, color: AppTheme.lightText)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primaryPurple.withValues(alpha: 0.2), AppTheme.primaryIndigo.withValues(alpha: 0.15)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on_rounded, size: 11, color: AppTheme.primaryPurple),
                          const SizedBox(width: 3),
                          Text('Universitas Pamulang', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryPurple)),
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

  Widget _buildStatsRow(QueueProvider queueProv) {
    return Row(
      children: [
        Expanded(child: _statCard('Hari Ini', '${queueProv.todayTotal}', Icons.today, AppTheme.primaryBlue)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Selesai', '${queueProv.todayCompleted}', Icons.check_circle, Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Menunggu', '${queueProv.waitingCount}', Icons.hourglass_empty, const Color(0xFFFFD93D))),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: AppTheme.lightText, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCurrentCalling(BuildContext context, QueueProvider queueProv) {
    final current = queueProv.currentCalling;
    return GlassCard(
      gradientColors: current != null
          ? [Colors.green.withValues(alpha: 0.1), Colors.white.withValues(alpha: 0.15)]
          : null,
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
                child: Icon(Icons.person_pin_rounded, color: AppTheme.primaryBlue, size: 18),
              ),
              const SizedBox(width: 10),
              Text('Sedang Dilayani', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
            ],
          ),
          const SizedBox(height: 14),
          if (current != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(current.ticketNumber, style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.green.shade600)),
                    const SizedBox(height: 4),
                    Text(current.userName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.darkText)),
                    Text(current.polyName, style: TextStyle(fontSize: 13, color: AppTheme.lightText)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      queueProv.completeQueue(current.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${current.ticketNumber} selesai')),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 20),
                        const SizedBox(width: 4),
                        Text('Selesai', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Icon(Icons.person_off_rounded, size: 44, color: AppTheme.lightText.withValues(alpha: 0.3)),
                    const SizedBox(height: 10),
                    Text('Tidak ada pasien dilayani', style: TextStyle(color: AppTheme.lightText, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          GlassButton(
            text: 'Panggil & Kelola Antrean',
            icon: Icons.navigate_next,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffManageQueue())),
            backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.85),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentQueue(BuildContext context, QueueProvider queueProv) {
    final recent = queueProv.queues.reversed.take(8).toList();
    if (recent.isEmpty) return const SizedBox.shrink();
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
                child: Icon(Icons.receipt_long_rounded, color: AppTheme.primaryBlue, size: 18),
              ),
              const SizedBox(width: 10),
              Text('Antrean Terbaru', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
            ],
          ),
          const SizedBox(height: 14),
          ...recent.map((q) => Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: q.status == QueueStatus.waiting
                        ? const Color(0xFFFFD93D).withValues(alpha: 0.15)
                        : q.status == QueueStatus.called
                            ? Colors.green.withValues(alpha: 0.15)
                            : q.status == QueueStatus.completed
                                ? Colors.blue.withValues(alpha: 0.15)
                                : Colors.red.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(q.ticketNumber, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                    color: q.status == QueueStatus.waiting
                        ? const Color(0xFFFFD93D)
                        : q.status == QueueStatus.called
                            ? Colors.green
                            : q.status == QueueStatus.completed
                                ? Colors.blue
                                : Colors.red)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(q.userName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.darkText))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor(q.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(_statusLabel(q.status), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _statusColor(q.status))),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Color _statusColor(QueueStatus status) {
    return switch (status) {
      QueueStatus.waiting => const Color(0xFFFFD93D),
      QueueStatus.called => Colors.green,
      QueueStatus.completed => Colors.blue,
      QueueStatus.cancelled => Colors.red,
    };
  }

  String _statusLabel(QueueStatus status) {
    return switch (status) {
      QueueStatus.waiting => 'Menunggu',
      QueueStatus.called => 'Dipanggil',
      QueueStatus.completed => 'Selesai',
      QueueStatus.cancelled => 'Batal',
    };
  }
}
