import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppProgress extends StatelessWidget {
  const AppProgress({
    super.key,
    required this.value,
    this.color = AppColors.gold,
    this.background = const Color(0x2971808A),
    this.height = 7,
    this.semanticLabel,
  });

  final double value;
  final Color color;
  final Color background;
  final double height;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final normalized = value.clamp(0, 100).toDouble();
    return Semantics(
      label: semanticLabel ?? 'Progres',
      value: '${normalized.round()} persen',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: background),
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: normalized / 100,
                child: ColoredBox(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
