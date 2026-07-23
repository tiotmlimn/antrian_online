enum QueueStatus { waiting, called, completed, cancelled }

class QueueModel {
  final String id;
  final String ticketNumber;
  final String userId;
  final String userName;
  final String polyId;
  final String polyName;
  final QueueStatus status;
  final DateTime createdAt;
  final String? estimatedTime;

  QueueModel({
    required this.id,
    required this.ticketNumber,
    required this.userId,
    required this.userName,
    required this.polyId,
    required this.polyName,
    this.status = QueueStatus.waiting,
    DateTime? createdAt,
    this.estimatedTime,
  }) : createdAt = createdAt ?? DateTime.now();

  QueueModel copyWith({QueueStatus? status, String? estimatedTime}) => QueueModel(
    id: id,
    ticketNumber: ticketNumber,
    userId: userId,
    userName: userName,
    polyId: polyId,
    polyName: polyName,
    status: status ?? this.status,
    createdAt: createdAt,
    estimatedTime: estimatedTime ?? this.estimatedTime,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'ticketNumber': ticketNumber,
    'userId': userId,
    'userName': userName,
    'polyId': polyId,
    'polyName': polyName,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'estimatedTime': estimatedTime,
  };

  factory QueueModel.fromMap(Map<String, dynamic> map) => QueueModel(
    id: map['id'],
    ticketNumber: map['ticketNumber'],
    userId: map['userId'],
    userName: map['userName'],
    polyId: map['polyId'],
    polyName: map['polyName'],
    status: QueueStatus.values.firstWhere((s) => s.name == map['status']),
    createdAt: DateTime.parse(map['createdAt']),
    estimatedTime: map['estimatedTime'],
  );
}
