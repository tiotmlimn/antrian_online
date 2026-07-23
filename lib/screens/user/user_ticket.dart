import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/queue_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../models/queue_model.dart';
import '../../models/user_model.dart';

class UserTicket extends StatelessWidget {
  const UserTicket({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isLoggedIn) return const SizedBox();
    final queueProv = context.watch<QueueProvider>();
    final user = auth.currentUser!;
    final myQueue = queueProv.getUserQueue(user.id);

    return Container(
      decoration: AppTheme.blurredBackground(),
      child: SafeArea(
        child: myQueue == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.confirmation_number_outlined, size: 80, color: AppTheme.lightText.withValues(alpha: 0.3)),
                    const SizedBox(height: 16),
                    Text('Belum ada antrean aktif', style: TextStyle(color: AppTheme.lightText, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Ambil antrean melalui halaman Beranda', style: TextStyle(color: AppTheme.lightText, fontSize: 13)),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: AppTheme.screenPadding,
                child: Column(
                  children: [
                    _buildTicketCard(context, myQueue, queueProv, user),
                    const SizedBox(height: 20),
                    _buildQRPlaceholder(),
                    const SizedBox(height: 20),
                    _buildCancelButton(context, myQueue, queueProv),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, QueueModel queue, QueueProvider queueProv, UserModel user) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryBlue.withValues(alpha: 0.55), AppTheme.primaryPurple.withValues(alpha: 0.35)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TIKET ANDA', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12, letterSpacing: 1)),
                      const SizedBox(height: 4),
                      Text(queue.ticketNumber, style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.local_hospital, color: Colors.white, size: 30),
                  ),
                ],
              ),
              const Divider(color: Colors.white24, height: 32),
              Row(
                children: [
                  _ticketInfo('Pasien', user.name),
                  const SizedBox(width: 24),
                  _ticketInfo('NIM', user.nim ?? '-'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _ticketInfo('Poli', queue.polyName),
                  const SizedBox(width: 24),
                  _ticketInfo('Estimasi', queue.estimatedTime ?? 'Menunggu'),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, color: Colors.white.withValues(alpha: 0.85), size: 16),
                      const SizedBox(width: 6),
                      Text('Sisa Antrean: ${queueProv.waitingQueues.length} orang',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ticketInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }

  Widget _buildQRPlaceholder() {
    return GlassCard(
      child: Column(
        children: [
          Text('Tunjukkan QR Code ke petugas', style: AppTheme.glassTextStyle),
          const SizedBox(height: 20),
          Container(
            width: 180, height: 180,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
            ),
            child: Icon(Icons.qr_code_2, size: 120, color: AppTheme.primaryBlue.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 12),
          Text('Scan untuk verifikasi', style: TextStyle(fontSize: 12, color: AppTheme.lightText)),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context, QueueModel queue, QueueProvider queueProv) {
    return GlassCard(
      child: SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Batalkan Antrean?'),
                content: const Text('Antrean Anda akan dibatalkan dan tidak bisa dikembalikan.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tidak')),
                  TextButton(
                    onPressed: () {
                      queueProv.cancelQueue(queue.id);
                      Navigator.pop(ctx);
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Ya, Batalkan'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
          label: const Text('Batalkan Antrean', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
