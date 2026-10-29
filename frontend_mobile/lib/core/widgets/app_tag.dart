import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum AppTagTone { teal, gold, neutral, navy }

class AppTag extends StatelessWidget {
  const AppTag({
    super.key,
    required this.label,
    this.tone = AppTagTone.teal,
  });

  final String label;
  final AppTagTone tone;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (tone) {
      AppTagTone.teal => (AppColors.tealSoft, AppColors.tealDark),
      AppTagTone.gold => (AppColors.goldSoft, const Color(0xFF916C22)),
      AppTagTone.neutral => (const Color(0xFFEEF1F2), const Color(0xFF647079)),
      AppTagTone.navy => (AppColors.navy, Colors.white),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 10,
          height: 1,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
          color: foreground,
        ),
      ),
    );
  }
}
