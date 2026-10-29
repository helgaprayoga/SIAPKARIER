import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_text_field.dart';
import '../../providers/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 30),
      children: [
        const _BrandMark(),
        const SizedBox(height: 32),
        Text(
          'Selamat datang\nkembali.',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Masuk untuk melanjutkan persiapan kariermu.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 30),
        AppTextField(
          label: 'Email',
          controller: _email,
          hint: 'nama@email.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: 'Kata sandi',
          controller: _password,
          hint: 'Masukkan kata sandi',
          obscureText: true,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 22),
        AppButton(
          label: 'Masuk',
          icon: LucideIcons.arrowRight,
          onPressed: _login,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Belum punya akun?',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            TextButton(
              onPressed: () => context.push('/register'),
              child: const Text('Buat akun'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: AppColors.goldSoft,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                LucideIcons.info,
                size: 17,
                color: Color(0xFF916C22),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Mode demo: gunakan email dan kata sandi apa pun untuk masuk. '
                  'Autentikasi Supabase akan dihubungkan pada tahap berikutnya.',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 10.5,
                    height: 1.5,
                    color: const Color(0xFF916C22),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Dengan masuk, kamu memahami bahwa SIAPKARIER adalah alat bantu '
          'persiapan karier, bukan layanan penempatan kerja.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _login() {
    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi email dan kata sandi.')),
      );
      return;
    }
    ref.read(authProvider.notifier).login(email: _email.text.trim());
    context.go('/home');
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            LucideIcons.compass,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'SIAPKARIER',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppColors.navyDeep,
          ),
        ),
      ],
    );
  }
}


