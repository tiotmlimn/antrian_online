import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final Color? bgColor;
  final List<Color>? gradientColors;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.blur = 8,
    this.padding = const EdgeInsets.all(20),
    this.borderColor,
    this.bgColor,
    this.gradientColors,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: padding,
              decoration: gradientColors != null
                  ? AppTheme.glassGradientDecoration(
                      borderRadius: borderRadius,
                      blur: blur,
                      borderColor: borderColor,
                      gradientColors: gradientColors,
                    )
                  : AppTheme.glassDecoration(
                      borderRadius: borderRadius,
                      blur: blur,
                      borderColor: borderColor,
                      bgColor: bgColor,
                    ),
              child: Material(
                type: MaterialType.transparency,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
