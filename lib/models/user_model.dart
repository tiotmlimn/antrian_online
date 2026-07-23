enum UserRole { user, staff, admin }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String? nim;
  final String? profilePhoto;
  final String? ktmUrl;
  final bool profilePhotoApproved;
  final bool ktmApproved;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.nim,
    this.profilePhoto,
    this.ktmUrl,
    this.profilePhotoApproved = false,
    this.ktmApproved = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  UserModel copyWith({
    String? name,
    String? email,
    UserRole? role,
    String? nim,
    String? profilePhoto,
    String? ktmUrl,
    bool? profilePhotoApproved,
    bool? ktmApproved,
    String? password,
  }) => UserModel(
    id: id,
    name: name ?? this.name,
    email: email ?? this.email,
    password: password ?? this.password,
    role: role ?? this.role,
    nim: nim ?? this.nim,
    profilePhoto: profilePhoto ?? this.profilePhoto,
    ktmUrl: ktmUrl ?? this.ktmUrl,
    profilePhotoApproved: profilePhotoApproved ?? this.profilePhotoApproved,
    ktmApproved: ktmApproved ?? this.ktmApproved,
    createdAt: createdAt,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'password': password,
    'role': role.name,
    'nim': nim,
    'profilePhoto': profilePhoto,
    'ktmUrl': ktmUrl,
    'profilePhotoApproved': profilePhotoApproved,
    'ktmApproved': ktmApproved,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'],
    name: map['name'],
    email: map['email'],
    password: map['password'],
    role: UserRole.values.firstWhere((r) => r.name == map['role']),
    nim: map['nim'],
    profilePhoto: map['profilePhoto'],
    ktmUrl: map['ktmUrl'],
    profilePhotoApproved: map['profilePhotoApproved'] ?? false,
    ktmApproved: map['ktmApproved'] ?? false,
    createdAt: DateTime.parse(map['createdAt']),
  );
}
