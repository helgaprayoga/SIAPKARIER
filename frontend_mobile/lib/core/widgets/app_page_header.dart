import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';

class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.onBack,
    this.action,
    this.eyebrowAboveTitle = false,
  });

  final String title;
  final String? eyebrow;
  final VoidCallback? onBack;
  final Widget? action;
  final bool eyebrowAboveTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (eyebrow != null && eyebrowAboveTitle) ...[
            Text(
              eyebrow!.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
                color: AppColors.teal,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (onBack != null) ...[
                Transform.translate(
                  offset: const Offset(-6, 0),
                  child: AppIconButton(
                    icon: LucideIcons.arrowLeft,
                    label: 'Kembali',
                    onPressed: onBack!,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    title,
                    style:
                        Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontSize: 22,
                              height: 1.2,
                            ),
                  ),
                ),
              ),
              ?action,
            ],
          ),
          if (eyebrow != null && !eyebrowAboveTitle) ...[
            const SizedBox(height: 8),
            Text(
              eyebrow!.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
                color: AppColors.teal,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
