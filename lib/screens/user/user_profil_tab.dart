import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../models/user_model.dart';

class UserProfilTab extends StatelessWidget {
  const UserProfilTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isLoggedIn) return const SizedBox();
    final user = auth.currentUser!;
    return SingleChildScrollView(
      padding: AppTheme.screenPadding,
      child: Column(
        children: [
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _showUrlDialog(context, 'Foto Profil', 'Masukkan URL foto profil',
              user.profilePhoto, (url) {
                context.read<AuthProvider>().updateProfilePhoto(user.id, url);
              }),
            child: Stack(
              children: [
                Container(
                  width: 96, height: 96,
                  decoration: BoxDecoration(
                    gradient: user.profilePhoto != null ? null : AppTheme.premiumGradient,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: AppTheme.primaryIndigo.withValues(alpha: 0.25), blurRadius: 24, offset: const Offset(0, 8)),
                    ],
                    image: user.profilePhoto != null
                        ? DecorationImage(image: NetworkImage(user.profilePhoto!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: user.profilePhoto == null
                      ? const Icon(Icons.person, color: Colors.white, size: 46)
                      : null,
                ),
                Positioned(
                  bottom: 0, right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryIndigo,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.edit, color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(user.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
          const SizedBox(height: 2),
          Text(user.email, style: TextStyle(fontSize: 13, color: AppTheme.lightText)),
          const SizedBox(height: 24),
          GlassCard(
            child: Column(
              children: [
                _profileRow(Icons.badge_outlined, 'NIM', user.nim ?? '-'),
                Divider(color: Colors.grey.withValues(alpha: 0.1), height: 1),
                _profileRow(Icons.school_outlined, 'Kampus', 'Universitas Pamulang'),
                Divider(color: Colors.grey.withValues(alpha: 0.1), height: 1),
                _profileRow(Icons.people_outlined, 'Role', user.role.name.toUpperCase()),
                Divider(color: Colors.grey.withValues(alpha: 0.1), height: 1),
                _profileRow(Icons.email_outlined, 'Email', user.email),
                Divider(color: Colors.grey.withValues(alpha: 0.1), height: 1),
                _buildKtmRow(context, user),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GlassCard(
            child: SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Yakin ingin keluar?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                        TextButton(
                          onPressed: () {
                            context.read<AuthProvider>().logout();
                            Navigator.pop(ctx);
                          },
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKtmRow(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryIndigo.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.image, color: AppTheme.primaryIndigo, size: 20),
          ),
          const SizedBox(width: 12),
          Text('KTM', style: TextStyle(color: AppTheme.lightText, fontSize: 13)),
          const Spacer(),
          if (user.ktmUrl != null)
            GestureDetector(
              onTap: () => _showKtmPreview(context, user.ktmUrl!),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.primaryIndigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Lihat', style: TextStyle(color: AppTheme.primaryIndigo, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _showKtmUrlDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(user.ktmUrl == null ? 'Upload' : 'Ganti',
                style: TextStyle(color: AppTheme.primaryBlue, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryIndigo.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primaryIndigo, size: 20),
          ),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: AppTheme.lightText, fontSize: 13)),
          const Spacer(),
          Text(value, style: TextStyle(color: AppTheme.darkText, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  void _showKtmUrlDialog(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser!;
    final controller = TextEditingController(text: user.ktmUrl ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Upload KTM'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Masukkan URL foto KTM',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              final url = controller.text.trim();
              if (url.isEmpty) return;
              if (!url.startsWith('http://') && !url.startsWith('https://')) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('URL tidak valid. Harus diawali http:// atau https://')),
                );
                return;
              }
              auth.updateKtmUrl(user.id, url);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('URL KTM berhasil disimpan'), duration: Duration(seconds: 2)),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showUrlDialog(BuildContext context, String title, String hint, String? current, Function(String) onSave) {
    final controller = TextEditingController(text: current ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            errorText: null,
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              final url = controller.text.trim();
              if (url.isEmpty) return;
              if (!url.startsWith('http://') && !url.startsWith('https://')) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('URL tidak valid. Harus diawali http:// atau https://')),
                );
                return;
              }
              onSave(url);
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showKtmPreview(BuildContext context, String url) {
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
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Container(
                  height: 300,
                  color: const Color(0xFF1E293B),
                  child: Image.network(url, fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Container(
                      height: 300,
                      color: const Color(0x991E293B),
                      child: const Center(child: Icon(Icons.broken_image, color: Colors.white54, size: 48)),
                    ),
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(height: 300, color: const Color(0x991E293B),
                          child: const Center(child: CircularProgressIndicator()));
                    },
                  ),
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
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
