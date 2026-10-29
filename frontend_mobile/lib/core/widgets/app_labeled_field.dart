import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppLabeledField extends StatelessWidget {
  const AppLabeledField({
    super.key,
    required this.label,
    this.initialValue,
    this.hint,
    this.helper,
    this.errorText,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.optional = false,
    this.obscureText = false,
  });

  final String label;
  final String? initialValue;
  final String? hint;
  final String? helper;
  final String? errorText;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final bool optional;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            if (optional) ...[
              const SizedBox(width: 5),
              const Text(
                'Opsional',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 9,
                  color: AppColors.muted,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 7),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          obscureText: obscureText,
          onChanged: onChanged,
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 13,
            color: AppColors.ink,
          ),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            helperText: helper,
            counterText: '',
            alignLabelWithHint: maxLines > 1,
          ),
        ),
      ],
    );
  }
}

