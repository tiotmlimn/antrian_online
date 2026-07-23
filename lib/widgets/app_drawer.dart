import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  final List<DrawerItem> items;
  final String currentRoute;

  const AppDrawer({
    super.key,
    required this.items,
    this.currentRoute = '',
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    if (user == null) return const SizedBox();

    return Drawer(
      width: 280,
      backgroundColor: const Color(0xFF0F172A),
      child: Column(
        children: [
          _buildHeader(user.name, user.email, user.nim, user.profilePhoto),
          const Divider(color: Colors.white24, height: 1),
          Expanded(child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.white.withValues(alpha: 0.08),
              highlightColor: Colors.white.withValues(alpha: 0.08),
            ),
            child: _buildMenuItems(context),
          )),
          _buildLogout(context),
        ],
      ),
    );
  }

  Widget _buildHeader(String name, String email, String? nim, String? profilePhoto) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              gradient: profilePhoto != null ? null : AppTheme.blueGradient,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: AppTheme.primaryBlue.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
              image: profilePhoto != null
                  ? DecorationImage(image: NetworkImage(profilePhoto), fit: BoxFit.cover)
                  : null,
            ),
            child: profilePhoto == null
                ? const Icon(Icons.person, color: Colors.white, size: 30)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 2),
                Text(email, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
                if (nim != null) ...[
                  const SizedBox(height: 2),
                  Text('NIM: $nim', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6))),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: ListTile(
            leading: Icon(item.icon, color: Colors.white.withValues(alpha: 0.7), size: 22),
            title: Text(item.title, style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 15,
            )),
            onTap: () {
              Navigator.pop(context);
              item.onTap.call();
            },
          ),
        );
      },
    );
  }

  Widget _buildLogout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent, size: 22),
              title: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600, fontSize: 15)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Yakin ingin keluar?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                      TextButton(
                        onPressed: () {
                          final auth = context.read<AuthProvider>();
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          auth.logout();
                        },
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
    );
  }
}

class DrawerItem {
  final String title;
  final IconData icon;
  final String route;
  final VoidCallback onTap;

  DrawerItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.onTap,
  });
}
