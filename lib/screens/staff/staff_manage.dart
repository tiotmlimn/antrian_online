import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../providers/queue_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_button.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/floating_app_bar.dart';
import '../../models/queue_model.dart';
import 'staff_dashboard.dart';

class StaffManageQueue extends StatefulWidget {
  const StaffManageQueue({super.key});

  @override
  State<StaffManageQueue> createState() => _StaffManageQueueState();
}

class _StaffManageQueueState extends State<StaffManageQueue> {
  String? _selectedPolyId;

  @override
  Widget build(BuildContext context) {
    final queueProv = context.watch<QueueProvider>();

    return Scaffold(
      drawer: AppDrawer(
        currentRoute: '/manage',
        items: [
          DrawerItem(title: 'Dashboard', icon: Icons.dashboard_rounded, route: '/', onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StaffDashboard()));
          }),
          DrawerItem(title: 'Kelola Antrean', icon: Icons.queue_rounded, route: '/manage', onTap: () {}),
        ],
      ),
      body: Container(
        decoration: AppTheme.blurredBackground(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FloatingAppBar(
                title: 'Kelola Antrean',
                leading: Builder(
                  builder: (ctx) => IconButton(
                    icon: Icon(Icons.menu_rounded, color: AppTheme.darkText),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: GlassIconButton(
                      icon: Icons.refresh,
                      label: 'Refresh',
                      onTap: () => setState(() {}),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppTheme.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPolyFilter(queueProv),
                      const SizedBox(height: 16),
                      if (_selectedPolyId != null)
                        _buildQueueList(context, queueProv, _selectedPolyId!)
                      else
                        _buildAllQueues(context, queueProv),
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

  Widget _buildPolyFilter(QueueProvider queueProv) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter Poli', style: AppTheme.glassTextStyle),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('Semua', null, AppTheme.primaryBlue),
                const SizedBox(width: 8),
                ...queueProv.polis.map((p) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _filterChip(p.name, p.id, AppTheme.primaryBlue),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String? id, Color color) {
    final selected = _selectedPolyId == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPolyId = id),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? color.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? color.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.3),
              ),
            ),
            child: Text(label, style: TextStyle(
              color: selected ? color : AppTheme.lightText,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildQueueList(BuildContext context, QueueProvider queueProv, String polyId) {
    final queues = queueProv.queues.where((q) =>
      q.polyId == polyId && (q.status == QueueStatus.waiting || q.status == QueueStatus.called)
    ).toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    if (queues.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 60, color: AppTheme.lightText.withValues(alpha: 0.4)),
              const SizedBox(height: 16),
              Text('Tidak ada antrean', style: TextStyle(color: AppTheme.lightText)),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        GlassButton(
          text: 'Panggil Antrean Selanjutnya',
          icon: Icons.navigate_next,
          onPressed: () {
            final called = queueProv.callNext(polyId);
            if (!called && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tidak ada antrean yang menunggu')),
              );
            } else if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Berhasil memanggil antrean')),
              );
            }
          },
          backgroundColor: Colors.green.withValues(alpha: 0.8),
        ),
        const SizedBox(height: 16),
        ...queues.map((q) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildQueueItem(context, q, queueProv),
        )),
      ],
    );
  }

  Widget _buildAllQueues(BuildContext context, QueueProvider queueProv) {
    final polyGroups = <String, List<QueueModel>>{};
    for (final q in queueProv.queues.where((q) => q.status == QueueStatus.waiting || q.status == QueueStatus.called)) {
      polyGroups.putIfAbsent(q.polyId, () => []);
      polyGroups[q.polyId]!.add(q);
    }
    if (polyGroups.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 60, color: AppTheme.lightText.withValues(alpha: 0.4)),
              const SizedBox(height: 16),
              Text('Tidak ada antrean', style: TextStyle(color: AppTheme.lightText)),
            ],
          ),
        ),
      );
    }
    return Column(
      children: polyGroups.entries.map((e) {
        final poly = queueProv.polis.firstWhere((p) => p.id == e.key);
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.medical_services, color: AppTheme.primaryBlue, size: 20),
                    const SizedBox(width: 8),
                    Text(poly.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
                    const Spacer(),
                    Text('${e.value.length}', style: TextStyle(fontSize: 14, color: AppTheme.lightText)),
                  ],
                ),
                const SizedBox(height: 12),
                ...e.value.map((q) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: q.status == QueueStatus.called
                              ? Colors.green.withValues(alpha: 0.15)
                              : const Color(0xFFFFD93D).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(q.ticketNumber, style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12,
                          color: q.status == QueueStatus.called ? Colors.green : const Color(0xFFFFD93D),
                        )),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(q.userName, style: TextStyle(fontSize: 13, color: AppTheme.darkText))),
                      IconButton(
                        icon: Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                        onPressed: q.status == QueueStatus.waiting ? null : () {
                          queueProv.completeQueue(q.id);
                        },
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQueueItem(BuildContext context, QueueModel q, QueueProvider queueProv) {
    final isCalled = q.status == QueueStatus.called;
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      gradientColors: isCalled
          ? [Colors.green.withValues(alpha: 0.1), Colors.white.withValues(alpha: 0.15)]
          : null,
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: isCalled ? Colors.green.withValues(alpha: 0.15) : const Color(0xFFFFD93D).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(q.ticketNumber.replaceAll(RegExp(r'[A-Z]-'), ''),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                  color: isCalled ? Colors.green : const Color(0xFFFFD93D))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(q.ticketNumber, style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.darkText)),
                Text(q.userName, style: TextStyle(fontSize: 12, color: AppTheme.lightText)),
              ],
            ),
          ),
          if (!isCalled)
            GlassIconButton(
              icon: Icons.double_arrow,
              label: 'Panggil',
              color: AppTheme.primaryBlue,
              onTap: () => queueProv.callNext(q.polyId),
            )
          else
            GlassIconButton(
              icon: Icons.check_circle,
              label: 'Selesai',
              color: Colors.green,
              onTap: () => queueProv.completeQueue(q.id),
            ),
        ],
      ),
    );
  }
}
