import 'package:flutter/material.dart';

/// Spacing, radius, dan shadow yang dipakai lintas fitur.
class AppSpacing {
  AppSpacing._();

  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 28.0;
  static const xxxl = 32.0;

  static const pageHorizontal = 22.0;
  static const pageTop = 18.0;
  static const pageBottomWithNav = 116.0;

  static const radiusSm = 12.0;
  static const radiusMd = 18.0;
  static const radiusLg = 26.0;

  static const shadowSm = [
    BoxShadow(
      color: Color(0x12183B56),
      blurRadius: 20,
      offset: Offset(0, 6),
    ),
  ];

  static const shadowLg = [
    BoxShadow(
      color: Color(0x24183B56),
      blurRadius: 70,
      offset: Offset(0, 28),
    ),
  ];
}
