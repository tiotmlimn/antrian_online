import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  final List<UserModel> _users = [
    UserModel(id: '1', name: 'Admin Kampus', email: 'admin@kampus.ac.id', password: 'admin123', role: UserRole.admin),
    UserModel(id: '2', name: 'Dr. Staff', email: 'staff@kampus.ac.id', password: 'staff123', role: UserRole.staff, nim: '19800101'),
    UserModel(id: '3', name: 'Mahasiswa User', email: 'user@kampus.ac.id', password: 'user123', role: UserRole.user, nim: '220101001'),
  ];

  UserModel? get currentUser => _currentUser;
  List<UserModel> get users => _users;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == UserRole.admin;
  bool get isStaff => _currentUser?.role == UserRole.staff;
  bool get isUser => _currentUser?.role == UserRole.user;

  bool login(String email, String password) {
    final user = _users.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => UserModel(id: '', name: '', email: '', password: '', role: UserRole.user),
    );
    if (user.id.isNotEmpty) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  bool register(String name, String email, String password, String nim) {
    if (_users.any((u) => u.email == email)) return false;
    _users.add(UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
      role: UserRole.user,
      nim: nim,
    ));
    return true;
  }

  void addUser(String name, String email, String password, UserRole role, {String? nim}) {
    _users.add(UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
      role: role,
      nim: nim,
    ));
    notifyListeners();
  }

  void removeUser(String id) {
    _users.removeWhere((u) => u.id == id);
    notifyListeners();
  }

  void updateUser(String id, String name, String email, UserRole role, {String? nim}) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx != -1) {
      _users[idx] = _users[idx].copyWith(
        name: name,
        email: email,
        role: role,
        nim: nim,
      );
      if (_currentUser?.id == id) _currentUser = _users[idx];
      notifyListeners();
    }
  }

  void updateProfilePhoto(String id, String url) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx != -1) {
      _users[idx] = _users[idx].copyWith(profilePhoto: url, profilePhotoApproved: false);
      if (_currentUser?.id == id) _currentUser = _users[idx];
      notifyListeners();
    }
  }

  void updateKtmUrl(String id, String url) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx != -1) {
      _users[idx] = _users[idx].copyWith(ktmUrl: url, ktmApproved: false);
      if (_currentUser?.id == id) _currentUser = _users[idx];
      notifyListeners();
    }
  }

  void clearProfilePhoto(String id) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx != -1) {
      _users[idx] = _users[idx].copyWith(profilePhoto: null, profilePhotoApproved: false);
      if (_currentUser?.id == id) _currentUser = _users[idx];
      notifyListeners();
    }
  }

  void clearKtmUrl(String id) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx != -1) {
      _users[idx] = _users[idx].copyWith(ktmUrl: null, ktmApproved: false);
      if (_currentUser?.id == id) _currentUser = _users[idx];
      notifyListeners();
    }
  }

  void approveProfilePhoto(String id) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx != -1) {
      _users[idx] = _users[idx].copyWith(profilePhotoApproved: true);
      if (_currentUser?.id == id) _currentUser = _users[idx];
      notifyListeners();
    }
  }

  void approveKtm(String id) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx != -1) {
      _users[idx] = _users[idx].copyWith(ktmApproved: true);
      if (_currentUser?.id == id) _currentUser = _users[idx];
      notifyListeners();
    }
  }
}
