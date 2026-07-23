import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_button.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/floating_app_bar.dart';
import '../../models/user_model.dart';
import 'admin_dashboard.dart';

class AdminManageUsers extends StatefulWidget {
  const AdminManageUsers({super.key});

  @override
  State<AdminManageUsers> createState() => _AdminManageUsersState();
}

class _AdminManageUsersState extends State<AdminManageUsers> {
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _nimC = TextEditingController();
  UserRole _role = UserRole.user;
  String? _editId;

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _passC.dispose();
    _nimC.dispose();
    super.dispose();
  }

  void _resetForm() {
    _nameC.clear();
    _emailC.clear();
    _passC.clear();
    _nimC.clear();
    setState(() {
      _role = UserRole.user;
      _editId = null;
    });
  }

  void _submit() {
    final auth = context.read<AuthProvider>();
    if (_nameC.text.trim().isEmpty || _emailC.text.trim().isEmpty) return;
    if (_editId != null) {
      auth.updateUser(_editId!, _nameC.text.trim(), _emailC.text.trim(), _role, nim: _nimC.text.trim().isEmpty ? null : _nimC.text.trim());
    } else {
      auth.addUser(_nameC.text.trim(), _emailC.text.trim(), _passC.text.isEmpty ? 'default123' : _passC.text, _role, nim: _nimC.text.trim().isEmpty ? null : _nimC.text.trim());
    }
    _resetForm();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_editId != null ? 'User diperbarui' : 'User ditambahkan')));
  }

  void _editUser(UserModel u) {
    _nameC.text = u.name;
    _emailC.text = u.email;
    _nimC.text = u.nim ?? '';
    setState(() {
      _editId = u.id;
      _role = u.role;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      drawer: AppDrawer(
        currentRoute: '/users',
        items: [
          DrawerItem(title: 'Dashboard', icon: Icons.dashboard_rounded, route: '/', onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboard()));
          }),
          DrawerItem(title: 'Kelola User', icon: Icons.people_rounded, route: '/users', onTap: () {}),
        ],
      ),
      body: Container(
        decoration: AppTheme.blurredBackground(),
        child: SafeArea(
          child: Column(
            children: [
              FloatingAppBar(
                title: 'Kelola User',
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
                      _buildUserList(auth),
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
          Text(_editId != null ? 'Edit User' : 'Tambah User', style: AppTheme.glassTextStyle),
          const SizedBox(height: 16),
          _field('Nama', _nameC, Icons.person),
          const SizedBox(height: 12),
          _field('Email', _emailC, Icons.email),
          const SizedBox(height: 12),
          if (_editId == null) _field('Password', _passC, Icons.lock, isPass: true),
          if (_editId == null) const SizedBox(height: 12),
          _field('NIM (opsional)', _nimC, Icons.badge),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<UserRole>(
                    value: _role,
                    isExpanded: true,
                    items: UserRole.values.map((r) => DropdownMenuItem(
                      value: r,
                      child: Text(r.name.toUpperCase(), style: TextStyle(color: AppTheme.darkText)),
                    )).toList(),
                    onChanged: (v) => setState(() => _role = v!),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: GlassButton(text: _editId != null ? 'Update' : 'Tambah', onPressed: _submit)),
              if (_editId != null) ...[
                const SizedBox(width: 12),
                Expanded(child: GlassButton(text: 'Batal', onPressed: _resetForm, backgroundColor: Colors.grey.withValues(alpha: 0.6))),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _field(String hint, TextEditingController c, IconData icon, {bool isPass = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: TextField(
          controller: c,
          obscureText: isPass,
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

  Widget _buildUserList(AuthProvider auth) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daftar User (${auth.users.length})', style: AppTheme.glassTextStyle),
          const SizedBox(height: 12),
          ...auth.users.map((u) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: u.role == UserRole.admin
                        ? AppTheme.primaryPurple.withValues(alpha: 0.2)
                        : u.role == UserRole.staff
                            ? AppTheme.primaryBlue.withValues(alpha: 0.2)
                            : Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    u.role == UserRole.admin ? Icons.admin_panel_settings
                        : u.role == UserRole.staff ? Icons.medical_services : Icons.person,
                    color: u.role == UserRole.admin ? AppTheme.primaryPurple
                        : u.role == UserRole.staff ? AppTheme.primaryBlue : Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(u.name, style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.darkText, fontSize: 13)),
                      Text(u.email, style: TextStyle(fontSize: 11, color: AppTheme.lightText)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: u.role == UserRole.admin
                        ? AppTheme.primaryPurple.withValues(alpha: 0.15)
                        : u.role == UserRole.staff
                            ? AppTheme.primaryBlue.withValues(alpha: 0.15)
                            : Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(u.role.name, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,
                    color: u.role == UserRole.admin ? AppTheme.primaryPurple
                        : u.role == UserRole.staff ? AppTheme.primaryBlue : Colors.green)),
                ),
                const SizedBox(width: 8),
                if (u.profilePhoto != null)
                  _photoIcon(u.profilePhoto!, 'Foto Profil', u.profilePhotoApproved, () => auth.approveProfilePhoto(u.id), () => auth.clearProfilePhoto(u.id)),
                if (u.ktmUrl != null)
                  _photoIcon(u.ktmUrl!, 'KTM', u.ktmApproved, () => auth.approveKtm(u.id), () => auth.clearKtmUrl(u.id)),
                GestureDetector(
                  onTap: () => _editUser(u),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(Icons.edit, size: 18, color: AppTheme.primaryBlue),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: u.role == UserRole.admin ? null : () => auth.removeUser(u.id),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(Icons.delete, size: 18, color: u.role == UserRole.admin ? Colors.grey : Colors.redAccent),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _photoIcon(String url, String label, bool approved, VoidCallback onApprove, VoidCallback onDelete) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _showPhotoPreview(url, label),
          child: Icon(
            approved ? Icons.check_circle : Icons.image,
            size: 18,
            color: approved ? Colors.green : Colors.orange,
          ),
        ),
        if (!approved)
          GestureDetector(
            onTap: onApprove,
            child: Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Icon(Icons.verified, size: 16, color: AppTheme.primaryBlue),
            ),
          ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Hapus'),
                content: Text('Hapus $label ini?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                  TextButton(
                    onPressed: () {
                      onDelete();
                      Navigator.pop(ctx);
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                    child: const Text('Hapus'),
                  ),
                ],
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Icon(Icons.delete, size: 16, color: Colors.redAccent),
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  void _showPhotoPreview(String url, String label) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Color(0xFF1E293B)),
                child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Container(
                height: 300,
                color: const Color(0xFF1E293B),
                child: Image.network(url, fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Container(
                    height: 300,
                    color: const Color(0x991E293B),
                    child: const Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 48, color: Colors.white38),
                        SizedBox(height: 8),
                        Text('Gagal memuat gambar', style: TextStyle(color: Colors.white38)),
                      ],
                    )),
                  ),
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Container(height: 300, color: const Color(0x991E293B),
                        child: const Center(child: CircularProgressIndicator()));
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E293B),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Tutup', style: TextStyle(color: Colors.white70)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


