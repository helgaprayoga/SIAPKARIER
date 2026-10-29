import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.helper,
    this.errorText,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.validator,
    this.textInputAction,
    this.optional = false,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? helper;
  final String? errorText;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
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
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          obscureText: obscureText,
          onChanged: onChanged,
          validator: validator,
          textInputAction: textInputAction,
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

