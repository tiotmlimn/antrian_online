import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedBar extends StatelessWidget {
  final bool isActive;

  const AnimatedBar({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 4),
      height: 3,
      width: isActive ? 20 : 0,
      decoration: BoxDecoration(
        color: AppTheme.primaryIndigo,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
