import 'package:material_ui/material_ui.dart';

/// Spacing scale (logical pixels). Use these instead of ad-hoc numbers.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Horizontal page gutter on compact screens.
  static const double gutter = 20;
}

/// Corner radii.
abstract final class AppRadii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
}

/// Layout breakpoints, aligned with Material window size classes.
abstract final class AppBreakpoints {
  /// At or above this width the shell uses a navigation rail.
  static const double medium = 600;

  /// At or above this width content uses three-column grids.
  static const double expanded = 840;

  /// Maximum readable content width on large screens.
  static const double maxContentWidth = 760;
}
