import 'package:flutter/material.dart';

class NavItemModel {
  final String title;
  final IconData icon;

  NavItemModel({required this.title, required this.icon});
}

List<NavItemModel> bottomNavItems = [
  NavItemModel(title: "Beranda", icon: Icons.dashboard_rounded),
  NavItemModel(title: "Layanan", icon: Icons.medical_services_rounded),
  NavItemModel(title: "Riwayat", icon: Icons.history_rounded),
  NavItemModel(title: "Profil", icon: Icons.person_rounded),
];
