import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Membungkus halaman dengan lebar maksimum 430 dan padding konsisten.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.children,
    this.bottomNavigationBar,
    this.padding,
    this.background,
    this.resizeToAvoidBottomInset = true,
  });

  final List<Widget> children;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry? padding;
  final Color? background;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SafeArea(
        top: true,
        bottom: bottomNavigationBar == null,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: ListView(
              padding: padding ??
                  const EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontal,
                    AppSpacing.pageTop,
                    AppSpacing.pageHorizontal,
                    30,
                  ),
              children: children,
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
