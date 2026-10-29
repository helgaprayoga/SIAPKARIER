import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  static const _items = [
    (label: 'Home', icon: LucideIcons.home, route: '/home'),
    (label: 'Readiness', icon: LucideIcons.sparkles, route: '/readiness'),
    (label: 'CV', icon: LucideIcons.fileText, route: '/cv'),
    (label: 'Learn', icon: LucideIcons.bookOpen, route: '/learn'),
    (label: 'Profile', icon: LucideIcons.user, route: '/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 76,
        decoration: const BoxDecoration(
          color: Color(0xF2FFFFFF),
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final active = currentIndex == index;
            return Expanded(
              child: Semantics(
                button: true,
                selected: active,
                label: item.label,
                child: InkWell(
                  onTap: () => context.go(item.route),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 3,
                        margin: const EdgeInsets.only(bottom: 7),
                        decoration: BoxDecoration(
                          color: active ? AppColors.teal : Colors.transparent,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(4),
                          ),
                        ),
                      ),
                      Icon(
                        item.icon,
                        size: 21,
                        color: active
                            ? AppColors.teal
                            : const Color(0xFF9AA3A9),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: active
                              ? AppColors.teal
                              : const Color(0xFF9AA3A9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

