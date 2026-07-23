import 'package:flutter/material.dart';
import '../models/queue_model.dart';
import '../models/poly_model.dart';

class QueueProvider extends ChangeNotifier {
  final List<QueueModel> _queues = [];
  QueueModel? _currentCalling;

  final List<PolyModel> _polis = [
    PolyModel(id: 'p1', name: 'Poli Umum', description: 'Layanan kesehatan umum'),
    PolyModel(id: 'p2', name: 'Poli Gigi', description: 'Layanan kesehatan gigi'),
    PolyModel(id: 'p3', name: 'Poli Mata', description: 'Layanan kesehatan mata'),
    PolyModel(id: 'p4', name: 'Poli Jiwa', description: 'Layanan konseling dan kesehatan jiwa'),
  ];

  List<QueueModel> get queues => _queues;
  QueueModel? get currentCalling => _currentCalling;
  List<PolyModel> get polis => _polis;

  List<QueueModel> get waitingQueues => _queues.where((q) => q.status == QueueStatus.waiting).toList();
  List<QueueModel> get calledQueues => _queues.where((q) => q.status == QueueStatus.called).toList();
  List<QueueModel> get completedQueues => _queues.where((q) => q.status == QueueStatus.completed).toList();

  QueueModel? getUserQueue(String userId) {
    final userQueues = _queues.where((q) => q.userId == userId && (q.status == QueueStatus.waiting || q.status == QueueStatus.called)).toList();
    return userQueues.isNotEmpty ? userQueues.last : null;
  }

  bool hasWaitingQueue(String userId) {
    return _queues.any((q) => q.userId == userId && q.status == QueueStatus.waiting);
  }

  String _generateTicketNumber(String polyId) {
    final poly = _polis.firstWhere((p) => p.id == polyId);
    final prefix = poly.name.contains('Umum') ? 'U' :
                  poly.name.contains('Gigi') ? 'G' :
                  poly.name.contains('Mata') ? 'M' : 'J';
    final count = _queues.where((q) => q.polyId == polyId && q.createdAt.day == DateTime.now().day).length + 1;
    return '$prefix-${count.toString().padLeft(3, '0')}';
  }

  bool addQueue(String userId, String userName, String polyId, String polyName) {
    if (hasWaitingQueue(userId)) return false;
    final ticket = _generateTicketNumber(polyId);
    _queues.add(QueueModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      ticketNumber: ticket,
      userId: userId,
      userName: userName,
      polyId: polyId,
      polyName: polyName,
    ));
    notifyListeners();
    return true;
  }

  bool callNext(String polyId) {
    final next = _queues.where(
      (q) => q.polyId == polyId && q.status == QueueStatus.waiting,
    ).toList();
    if (next.isEmpty) return false;
    final sorted = next..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final idx = _queues.indexOf(sorted.first);
    _queues[idx] = sorted.first.copyWith(status: QueueStatus.called);
    _currentCalling = _queues[idx];
    notifyListeners();
    return true;
  }

  void completeQueue(String queueId) {
    final idx = _queues.indexWhere((q) => q.id == queueId);
    if (idx != -1) {
      _queues[idx] = _queues[idx].copyWith(status: QueueStatus.completed);
      _currentCalling = null;
      notifyListeners();
    }
  }

  void cancelQueue(String queueId) {
    final idx = _queues.indexWhere((q) => q.id == queueId);
    if (idx != -1) {
      _queues[idx] = _queues[idx].copyWith(status: QueueStatus.cancelled);
      if (_currentCalling?.id == queueId) _currentCalling = null;
      notifyListeners();
    }
  }

  void removeQueue(String queueId) {
    _queues.removeWhere((q) => q.id == queueId);
    notifyListeners();
  }

  void addPoly(String name, String description) {
    _polis.add(PolyModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
    ));
    notifyListeners();
  }

  void removePoly(String id) {
    _polis.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void togglePolyActive(String id) {
    final idx = _polis.indexWhere((p) => p.id == id);
    if (idx != -1) {
      final p = _polis[idx];
      _polis[idx] = PolyModel(id: p.id, name: p.name, description: p.description, isActive: !p.isActive);
      notifyListeners();
    }
  }

  int get todayTotal {
    return _queues.where((q) =>
      q.createdAt.year == DateTime.now().year &&
      q.createdAt.month == DateTime.now().month &&
      q.createdAt.day == DateTime.now().day
    ).length;
  }

  int get todayCompleted {
    return _queues.where((q) =>
      q.status == QueueStatus.completed &&
      q.createdAt.year == DateTime.now().year &&
      q.createdAt.month == DateTime.now().month &&
      q.createdAt.day == DateTime.now().day
    ).length;
  }

  int get waitingCount => waitingQueues.length;
}
