import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_button.dart';

class StickyActionBar extends StatelessWidget {
  const StickyActionBar({
    super.key,
    this.primaryLabel,
    this.onPrimary,
    this.primaryIcon,
    this.secondaryLabel,
    this.onSecondary,
    this.secondaryIcon,
    this.note,
    this.primaryEnabled = true,
    this.primaryVariant = AppButtonVariant.primary,
  });

  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final IconData? primaryIcon;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final IconData? secondaryIcon;
  final String? note;
  final bool primaryEnabled;
  final AppButtonVariant primaryVariant;

  @override
  Widget build(BuildContext context) {
    final hasSecondary = secondaryLabel != null && onSecondary != null;
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xF7FFFFFF),
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasSecondary)
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AppButton(
                      label: secondaryLabel!,
                      onPressed: onSecondary,
                      variant: AppButtonVariant.ghost,
                      icon: secondaryIcon,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 6,
                    child: AppButton(
                      label: primaryLabel ?? 'Lanjut',
                      onPressed: primaryEnabled ? onPrimary : null,
                      icon: primaryIcon,
                      variant: primaryVariant,
                    ),
                  ),
                ],
              )
            else if (primaryLabel != null)
              AppButton(
                label: primaryLabel!,
                onPressed: primaryEnabled ? onPrimary : null,
                icon: primaryIcon,
                variant: primaryVariant,
              ),
            if (note != null) ...[
              const SizedBox(height: 7),
              Text(
                note!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 9,
                  color: AppColors.muted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
