import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../providers/queue_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_button.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/floating_app_bar.dart';
import 'admin_dashboard.dart';
import 'admin_manage_users.dart';

class AdminManagePoly extends StatefulWidget {
  const AdminManagePoly({super.key});

  @override
  State<AdminManagePoly> createState() => _AdminManagePolyState();
}

class _AdminManagePolyState extends State<AdminManagePoly> {
  final _nameC = TextEditingController();
  final _descC = TextEditingController();

  @override
  void dispose() {
    _nameC.dispose();
    _descC.dispose();
    super.dispose();
  }

  void _addPoly() {
    if (_nameC.text.trim().isEmpty) return;
    context.read<QueueProvider>().addPoly(_nameC.text.trim(), _descC.text.trim());
    _nameC.clear();
    _descC.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Poli berhasil ditambahkan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final queueProv = context.watch<QueueProvider>();

    return Scaffold(
      drawer: AppDrawer(
        currentRoute: '/poly',
        items: [
          DrawerItem(title: 'Dashboard', icon: Icons.dashboard_rounded, route: '/', onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboard()));
          }),
          DrawerItem(title: 'Kelola User', icon: Icons.people_rounded, route: '/users', onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminManageUsers()));
          }),
          DrawerItem(title: 'Kelola Poli', icon: Icons.medical_services_rounded, route: '/poly', onTap: () {}),
        ],
      ),
      body: Container(
        decoration: AppTheme.blurredBackground(),
        child: SafeArea(
          child: Column(
            children: [
              FloatingAppBar(
                title: 'Kelola Poli',
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
                    children: [
                      _buildForm(),
                      const SizedBox(height: 20),
                      _buildPolyList(queueProv),
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

  Widget _buildForm() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tambah Poli Baru', style: AppTheme.glassTextStyle),
          const SizedBox(height: 16),
          _buildField('Nama Poli', _nameC, Icons.medical_services),
          const SizedBox(height: 12),
          _buildField('Deskripsi (opsional)', _descC, Icons.description, maxLines: 2),
          const SizedBox(height: 16),
          GlassButton(text: 'Tambah Poli', icon: Icons.add, onPressed: _addPoly),
        ],
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController c, IconData icon, {int maxLines = 1}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: TextField(
          controller: c,
          maxLines: maxLines,
          style: TextStyle(color: AppTheme.darkText),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppTheme.lightText.withValues(alpha: 0.6)),
            prefixIcon: Icon(icon, color: AppTheme.primaryBlue, size: 20),
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPolyList(QueueProvider queueProv) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daftar Poli', style: AppTheme.glassTextStyle),
          const SizedBox(height: 12),
          ...queueProv.polis.map((p) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    gradient: AppTheme.blueGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.medical_services, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name, style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.darkText)),
                      if (p.description.isNotEmpty)
                        Text(p.description, style: TextStyle(fontSize: 11, color: AppTheme.lightText)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: p.isActive
                        ? Colors.green.withValues(alpha: 0.15)
                        : Colors.red.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    p.isActive ? 'Buka' : 'Tutup',
                    style: TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold,
                      color: p.isActive ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => queueProv.togglePolyActive(p.id),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      p.isActive ? Icons.toggle_on : Icons.toggle_off_outlined,
                      color: p.isActive ? Colors.green : Colors.grey,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Hapus ${p.name}?'),
                        content: const Text('Poli akan dihapus permanen.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                          TextButton(
                            onPressed: () {
                              queueProv.removePoly(p.id);
                              Navigator.pop(ctx);
                            },
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
