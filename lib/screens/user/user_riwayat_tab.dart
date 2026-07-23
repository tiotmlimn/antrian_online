import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/queue_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../models/queue_model.dart';

class UserRiwayatTab extends StatelessWidget {
  const UserRiwayatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isLoggedIn) return const SizedBox();
    final user = auth.currentUser!;
    final queueProv = context.watch<QueueProvider>();
    final history = queueProv.queues.where((q) => q.userId == user.id).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return SingleChildScrollView(
      padding: AppTheme.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          if (history.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    Icon(Icons.history_rounded, size: 80, color: AppTheme.lightText.withValues(alpha: 0.3)),
                    const SizedBox(height: 16),
                    Text('Belum ada riwayat', style: TextStyle(color: AppTheme.lightText, fontSize: 16)),
                  ],
                ),
              ),
            )
          else
            ...history.map((q) => GlassCard(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: q.status == QueueStatus.completed
                          ? Colors.green.withValues(alpha: 0.15)
                          : q.status == QueueStatus.cancelled
                              ? Colors.red.withValues(alpha: 0.15)
                              : q.status == QueueStatus.called
                                  ? Colors.green.withValues(alpha: 0.15)
                                  : const Color(0xFFFFD93D).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        q.status == QueueStatus.completed ? Icons.check_circle_rounded
                            : q.status == QueueStatus.cancelled ? Icons.cancel_rounded
                            : q.status == QueueStatus.called ? Icons.notifications_active_rounded
                            : Icons.hourglass_bottom,
                        color: q.status == QueueStatus.completed ? Colors.green
                            : q.status == QueueStatus.cancelled ? Colors.red
                            : q.status == QueueStatus.called ? Colors.green
                            : const Color(0xFFFFD93D),
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(q.ticketNumber, style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.darkText, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(q.polyName, style: TextStyle(fontSize: 12, color: AppTheme.lightText)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: q.status == QueueStatus.completed
                          ? Colors.green.withValues(alpha: 0.1)
                          : q.status == QueueStatus.cancelled
                              ? Colors.red.withValues(alpha: 0.1)
                              : q.status == QueueStatus.called
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : const Color(0xFFFFD93D).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      q.status == QueueStatus.completed ? 'Selesai'
                          : q.status == QueueStatus.cancelled ? 'Batal'
                          : q.status == QueueStatus.called ? 'Dipanggil'
                          : 'Menunggu',
                      style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w700,
                        color: q.status == QueueStatus.completed ? Colors.green
                            : q.status == QueueStatus.cancelled ? Colors.red
                            : q.status == QueueStatus.called ? Colors.green
                            : const Color(0xFFFFD93D),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (q.status == QueueStatus.completed || q.status == QueueStatus.cancelled)
                    GestureDetector(
                      onTap: () => _confirmDeleteRiwayat(context, queueProv, q.id),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(Icons.delete_outline, size: 18, color: Colors.redAccent.withValues(alpha: 0.7)),
                      ),
                    ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  void _confirmDeleteRiwayat(BuildContext context, QueueProvider queueProv, String queueId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: Text('Hapus Riwayat', style: TextStyle(color: AppTheme.darkText)),
        content: Text('Yakin ingin menghapus riwayat ini?', style: TextStyle(color: AppTheme.lightText)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: TextStyle(color: AppTheme.lightText)),
          ),
          TextButton(
            onPressed: () {
              queueProv.removeQueue(queueId);
              Navigator.pop(ctx);
            },
            child: Text('Hapus', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
