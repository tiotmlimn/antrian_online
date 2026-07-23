import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/queue_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../models/queue_model.dart';
import '../../models/user_model.dart';

class UserBerandaTab extends StatelessWidget {
  const UserBerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final queueProv = context.watch<QueueProvider>();
    final user = auth.currentUser!;
    final myQueue = queueProv.getUserQueue(user.id);
    final hasActiveQueue = myQueue != null && (myQueue.status == QueueStatus.waiting || myQueue.status == QueueStatus.called);

    if (hasActiveQueue) {
      return SingleChildScrollView(
        padding: AppTheme.screenPadding.copyWith(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCampusCard(user.name, user.nim ?? ''),
            const SizedBox(height: 20),
            _buildActiveQueue(context, myQueue, queueProv),
            const SizedBox(height: 20),
            _buildQueueHistory(context, queueProv, user.id),
            const SizedBox(height: 20),
            _buildFooter(),
          ],
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        padding: AppTheme.screenPadding.copyWith(bottom: 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCampusCard(user.name, user.nim ?? ''),
            const SizedBox(height: 20),
            _buildEmptyQueue(),
            const SizedBox(height: 24),
            _buildAmbilAntreanButton(context, false),
            const SizedBox(height: 20),
            _buildQuickStats(queueProv),
            const SizedBox(height: 12),
            _buildActivePolis(queueProv),
            const SizedBox(height: 20),
            if (myQueue != null) ...[
              const SizedBox(height: 20),
              _buildQueueHistory(context, queueProv, user.id),
            ],
            const SizedBox(height: 20),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildCampusCard(String name, String nim) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryBlue.withValues(alpha: 0.25),
                AppTheme.primaryIndigo.withValues(alpha: 0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/logosi.jpeg', width: 56, height: 56, fit: BoxFit.cover),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.darkText,
                    )),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.badge_outlined, size: 13, color: AppTheme.lightText),
                        const SizedBox(width: 4),
                        Text('NIM: $nim', style: TextStyle(fontSize: 12, color: AppTheme.lightText)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primaryBlue.withValues(alpha: 0.2), AppTheme.primaryIndigo.withValues(alpha: 0.15)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on_rounded, size: 11, color: AppTheme.primaryIndigo),
                          const SizedBox(width: 3),
                          Text('Universitas Pamulang', style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryIndigo,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.verified_rounded, color: Colors.green, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyQueue() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      child: Column(
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryIndigo.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.queue_rounded, size: 44, color: AppTheme.primaryIndigo.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 20),
          Text('Belum ada antrean aktif',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.darkText),
          ),
          const SizedBox(height: 8),
          Text('Tekan tombol di bawah untuk\nmengambil nomor antrean',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppTheme.lightText, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(QueueProvider queueProv) {
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                Icon(Icons.queue_rounded, size: 28, color: AppTheme.primaryIndigo.withValues(alpha: 0.6)),
                const SizedBox(height: 8),
                Text('${queueProv.todayTotal}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
                const SizedBox(height: 2),
                Text('Total Antrean', style: TextStyle(fontSize: 11, color: AppTheme.lightText)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                Icon(Icons.check_circle_rounded, size: 28, color: Colors.green.withValues(alpha: 0.6)),
                const SizedBox(height: 8),
                Text('${queueProv.todayCompleted}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
                const SizedBox(height: 2),
                Text('Selesai', style: TextStyle(fontSize: 11, color: AppTheme.lightText)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivePolis(QueueProvider queueProv) {
    final activePolis = queueProv.polis.where((p) => p.isActive).toList();
    final colors = [AppTheme.primaryBlue, AppTheme.primaryPurple, AppTheme.softGreen, AppTheme.softCoral];

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.medical_services_rounded, color: Colors.green, size: 16),
              ),
              const SizedBox(width: 10),
              Text('Poli Buka Hari Ini', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
            ],
          ),
          const SizedBox(height: 14),
          ...activePolis.map((p) {
            final color = colors[queueProv.polis.indexOf(p) % colors.length];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.medical_services_outlined, color: color, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(p.name, style: TextStyle(fontSize: 13, color: AppTheme.darkText)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('Buka', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.green)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAmbilAntreanButton(BuildContext context, bool hasWaiting) {
    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: hasWaiting
                  ? LinearGradient(
                      colors: [Colors.grey.withValues(alpha: 0.5), Colors.grey.withValues(alpha: 0.3)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : LinearGradient(
                      colors: [
                        AppTheme.primaryIndigo.withValues(alpha: 0.75),
                        AppTheme.primaryBlue.withValues(alpha: 0.55),
                        AppTheme.primaryPurple.withValues(alpha: 0.4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: hasWaiting
                  ? null
                  : [
                      BoxShadow(
                        color: AppTheme.primaryIndigo.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: hasWaiting ? null : () => _showPolySelection(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      hasWaiting ? 'Menunggu antrean aktif...' : 'Ambil Antrean',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: hasWaiting ? 0.5 : 1),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPolySelection(BuildContext context) {
    final queueProv = context.read<QueueProvider>();
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser!;

    if (queueProv.hasWaitingQueue(user.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda masih memiliki antrean yang menunggu')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (ctx) {
        return GlassCard(
          margin: const EdgeInsets.fromLTRB(16, 60, 16, 16),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text('Pilih Poli', style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,
              )),
              const SizedBox(height: 4),
              Text('Ambil nomor antrean sesuai poli yang dituju',
                style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6)),
              ),
              const SizedBox(height: 20),
              ...queueProv.polis.where((p) => p.isActive).map((poly) {
                final colors = [AppTheme.primaryBlue, AppTheme.primaryPurple, AppTheme.softGreen, AppTheme.softCoral];
                final color = colors[queueProv.polis.indexOf(poly) % colors.length];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color.withValues(alpha: 0.2), Colors.white.withValues(alpha: 0.08)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: color.withValues(alpha: 0.3)),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            queueProv.addQueue(user.id, user.name, poly.id, poly.name);
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Antrean ${poly.name} berhasil diambil')),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.medical_services_outlined, color: color, size: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(poly.name, style: TextStyle(
                                        fontWeight: FontWeight.w700, color: Colors.white, fontSize: 15,
                                      )),
                                      const SizedBox(height: 2),
                                      Text(poly.description, style: TextStyle(
                                        fontSize: 12, color: Colors.white.withValues(alpha: 0.6),
                                      )),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.add_rounded, color: Colors.white, size: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 4),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActiveQueue(BuildContext context, QueueModel queue, QueueProvider queueProv) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser!;

    return ClipPath(
      clipper: const _TicketShapeClipper(),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryIndigo.withValues(alpha: 0.7),
                    AppTheme.primaryBlue.withValues(alpha: 0.5),
                    AppTheme.primaryPurple.withValues(alpha: 0.35),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryIndigo.withValues(alpha: 0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
                    child: Column(
                      children: [
                        Text('TIKET ANTRIAN', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('Antrian Online Kesehatan Kampus', style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 10)),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(queue.polyName, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12, fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(height: 20),
                        Text(queue.ticketNumber, style: const TextStyle(
                          color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 3,
                        )),
                        const SizedBox(height: 8),
                        Text('Nomor Antrian', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11, letterSpacing: 1)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: queue.status == QueueStatus.called
                                ? Colors.green.withValues(alpha: 0.2)
                                : const Color(0xFFFFD93D).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: queue.status == QueueStatus.called
                                  ? Colors.green.withValues(alpha: 0.4)
                                  : const Color(0xFFFFD93D).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            queue.status == QueueStatus.called ? 'Sedang Dipanggil' : 'Menunggu',
                            style: TextStyle(
                              color: queue.status == QueueStatus.called ? Colors.green : const Color(0xFFFFD93D),
                              fontSize: 11, fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(5))),
                        Expanded(child: Container(height: 1, margin: const EdgeInsets.symmetric(horizontal: 8), child: const DashedLine())),
                        Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(5))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: _ticketInfo(Icons.person_outline, 'Pasien', user.name),
                        ),
                        Container(width: 1, height: 30, color: Colors.white.withValues(alpha: 0.1)),
                        Expanded(
                          child: _ticketInfo(Icons.badge_outlined, 'NIM', user.nim ?? '-'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                      border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                    ),
                    child: TextButton(
                      onPressed: () => _showTicketDetail(context, queue, user),
                      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: Text('Lihat Detail Tiket', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _TicketBorderPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ticketInfo(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.5)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 9, letterSpacing: 1)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildQueueHistory(BuildContext context, QueueProvider queueProv, String userId) {
    final history = queueProv.queues.where((q) => q.userId == userId && q.status == QueueStatus.completed).toList();
    if (history.isEmpty) return const SizedBox.shrink();
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.history_rounded, color: Colors.green, size: 16),
              ),
              const SizedBox(width: 10),
              Text('Riwayat Antrean', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
            ],
          ),
          const SizedBox(height: 14),
          ...history.reversed.take(5).map((q) => Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(q.ticketNumber.replaceAll(RegExp(r'[A-Z]-'), ''),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(q.ticketNumber, style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.darkText, fontSize: 13)),
                      Text(q.polyName, style: TextStyle(fontSize: 11, color: AppTheme.lightText)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('Selesai', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  void _showTicketDetail(BuildContext context, QueueModel queue, UserModel user) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      barrierLabel: "Ticket Detail",
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
      pageBuilder: (context, a, b) => Stack(
        children: [
          Positioned(
            top: -50, left: -50, right: -50, bottom: -50,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(color: Colors.black.withValues(alpha: 0.15)),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GlassCard(
              borderRadius: 32,
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppTheme.premiumGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: AppTheme.primaryIndigo.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6)),
                        ],
                      ),
                      child: const Icon(Icons.confirmation_number_rounded, color: Colors.white, size: 36),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(queue.ticketNumber, style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.darkText, letterSpacing: 2)),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: queue.status == QueueStatus.called ? Colors.green.withValues(alpha: 0.1) : AppTheme.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        queue.status == QueueStatus.called ? 'DIPANGGIL' : 'MENUNGGU',
                        style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1,
                          color: queue.status == QueueStatus.called ? Colors.green : AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _detailRow(Icons.person_outline, 'Pasien', user.name),
                  const SizedBox(height: 12),
                  _detailRow(Icons.badge_outlined, 'NIM', user.nim ?? '-'),
                  const SizedBox(height: 12),
                  _detailRow(Icons.medical_services_outlined, 'Poli', queue.polyName),
                  const SizedBox(height: 12),
                  _detailRow(Icons.access_time_rounded, 'Estimasi', queue.estimatedTime ?? 'Menunggu'),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryIndigo),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(fontSize: 13, color: AppTheme.lightText)),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.darkText)),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 20),
        child: Text('HealthCampus v1.0', style: TextStyle(fontSize: 11, color: AppTheme.lightText.withValues(alpha: 0.5))),
      ),
    );
  }
}

class DashedLine extends StatelessWidget {
  const DashedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashWidth = 6.0;
        final dashSpace = 4.0;
        final totalWidth = constraints.constrainWidth();
        final dashCount = (totalWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) => Container(
            width: dashWidth,
            height: 1,
            color: Colors.white.withValues(alpha: 0.2),
          )),
        );
      },
    );
  }
}

class _TicketShapeClipper extends CustomClipper<Path> {
  const _TicketShapeClipper();

  static Path ticketPath(Size size) {
    const cr = 16.0;
    const r = 24.0;
    final w = size.width;
    final h = size.height;
    final cy = h * 0.58;

    final base = Path()..addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(r),
    ));

    final leftHole = Path()..addOval(Rect.fromCircle(
      center: Offset(0, cy), radius: cr,
    ));

    final rightHole = Path()..addOval(Rect.fromCircle(
      center: Offset(w, cy), radius: cr,
    ));

    final holes = Path.combine(PathOperation.union, leftHole, rightHole);
    return Path.combine(PathOperation.difference, base, holes);
  }

  @override
  Path getClip(Size size) => ticketPath(size);

  @override
  bool shouldReclip(_TicketShapeClipper oldClipper) => false;
}

class _TicketBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(_TicketShapeClipper.ticketPath(size), paint);
  }

  @override
  bool shouldRepaint(_TicketBorderPainter oldDelegate) => false;
}
