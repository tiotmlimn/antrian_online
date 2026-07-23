import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/queue_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class UserLayananTab extends StatelessWidget {
  const UserLayananTab({super.key});

  @override
  Widget build(BuildContext context) {
    final queueProv = context.watch<QueueProvider>();
    final polis = queueProv.polis;
    final colors = [AppTheme.primaryBlue, AppTheme.primaryPurple, AppTheme.softGreen, AppTheme.softCoral];

    return SingleChildScrollView(
      padding: AppTheme.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text('Layanan Poli', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
          const SizedBox(height: 4),
          Text('Poli yang tersedia di Kampus', style: TextStyle(fontSize: 12, color: AppTheme.lightText)),
          const SizedBox(height: 16),
          ...polis.map((p) {
            final color = colors[polis.indexOf(p) % colors.length];
            return GlassCard(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [color.withValues(alpha: 0.7), color.withValues(alpha: 0.3)]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.medical_services, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.darkText, fontSize: 14)),
                        if (p.description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(p.description, style: TextStyle(fontSize: 11, color: AppTheme.lightText)),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: p.isActive
                          ? Colors.green.withValues(alpha: 0.15)
                          : Colors.red.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      p.isActive ? 'Buka' : 'Tutup',
                      style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700,
                        color: p.isActive ? Colors.green : Colors.red,
                      ),
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
