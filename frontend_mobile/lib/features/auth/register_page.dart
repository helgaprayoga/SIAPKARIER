import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_text_field.dart';
import '../../providers/auth_controller.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _program = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _program.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(LucideIcons.arrowLeft),
              tooltip: 'Kembali',
            ),
            const SizedBox(width: 4),
            const Text(
              'Buat akun',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.navyDeep,
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          'Mulai ruang\ntumbuhmu.',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Satu akun untuk menyimpan progres persiapan kariermu.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 26),
        AppTextField(
          label: 'Nama lengkap',
          controller: _name,
          hint: 'Nama yang ingin ditampilkan',
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: 'Email',
          controller: _email,
          hint: 'nama@email.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: 'Program studi',
          controller: _program,
          hint: 'Contoh: Sistem Informasi',
          textInputAction: TextInputAction.next,
          optional: true,
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: 'Kata sandi',
          controller: _password,
          hint: 'Minimal 8 karakter',
          obscureText: true,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: 'Ulangi kata sandi',
          controller: _confirm,
          hint: 'Masukkan kata sandi lagi',
          obscureText: true,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 22),
        AppButton(
          label: 'Buat akun',
          icon: LucideIcons.arrowRight,
          onPressed: _register,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sudah punya akun?',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Masuk'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Mode demo: akun disimpan di perangkat. Autentikasi Supabase akan '
          'dihubungkan pada tahap berikutnya.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _register() {
    final name = _name.text.trim();
    final email = _email.text.trim();
    final password = _password.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama, email, dan kata sandi wajib diisi.')),
      );
      return;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email belum sesuai.')),
      );
      return;
    }
    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi minimal 8 karakter.')),
      );
      return;
    }
    if (password != _confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi belum sama.')),
      );
      return;
    }

    ref.read(authProvider.notifier).register(
          name: name,
          email: email,
          studyProgram: _program.text.trim().isEmpty
              ? null
              : _program.text.trim(),
        );
    context.go('/home');
  }
}

