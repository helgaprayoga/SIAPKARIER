import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.expand = true,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool expand;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && onPressed != null;
    final (background, foreground, border) = switch (variant) {
      AppButtonVariant.primary => (
          AppColors.teal,
          Colors.white,
          null,
        ),
      AppButtonVariant.secondary => (
          Colors.white,
          AppColors.navy,
          AppColors.line,
        ),
      AppButtonVariant.ghost => (
          AppColors.background,
          AppColors.navy,
          null,
        ),
    };

    final button = SizedBox(
      height: 51,
      width: expand ? double.infinity : null,
      child: Material(
        color: isEnabled ? background : background.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              border: border == null ? null : Border.all(color: border),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isEnabled
                          ? foreground
                          : foreground.withValues(alpha: 0.55),
                    ),
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 9),
                  Icon(
                    icon,
                    size: 18,
                    color: isEnabled
                        ? foreground
                        : foreground.withValues(alpha: 0.55),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: label,
      child: button,
    );
  }
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.size = 42,
    this.iconSize = 20,
    this.background = AppColors.background,
    this.foreground = AppColors.navy,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? label;
  final double size;
  final double iconSize;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: SizedBox(
        width: size,
        height: size,
        child: Material(
          color: background,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Icon(icon, size: iconSize, color: foreground),
          ),
        ),
      ),
    );
  }
}

/// Ikon panah kanan yang sering dipakai pada kartu.
class AppChevron extends StatelessWidget {
  const AppChevron({super.key, this.size = 18, this.color = AppColors.muted});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(LucideIcons.chevronRight, size: size, color: color);
  }
}

