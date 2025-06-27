import 'package:flutter/material.dart';

/// From: docs/ui_specifications/design_system/design_tokens.md

// Animation System
class AppAnimations {
  // Durations
  static const Duration fast = Duration(milliseconds: 100); // Hover, press
  static const Duration medium =
      Duration(milliseconds: 200); // Slide (drawers, menus)
  static const Duration slow =
      Duration(milliseconds: 300); // Fade, page transitions
  static const Duration toast = Duration(milliseconds: 250); // Toast/snackbar
  static const Duration shimmer =
      Duration(milliseconds: 1200); // Skeleton shimmer

  // Easing Curves
  static const Curve snapIn =
      Cubic(0.4, 0.0, 1.0, 1.0); // Hover highlight, press down
  static const Curve snapOut =
      Cubic(0.0, 0.0, 0.2, 1.0); // Press release, fade, toast
  static const Curve slide =
      Cubic(0.4, 0.0, 0.2, 1.0); // Slide (drawers, menus, page transitions)
  static const Curve shimmerCurve = Curves.linear; // Skeleton shimmer

  // Specific Animation Configurations
  static const AnimationConfig hoverHighlight = AnimationConfig(
    duration: fast,
    curve: snapIn,
  );

  static const AnimationConfig pressDown = AnimationConfig(
    duration: fast,
    curve: snapIn,
  );

  static const AnimationConfig pressRelease = AnimationConfig(
    duration: fast,
    curve: snapOut,
  );

  static const AnimationConfig fadeModal = AnimationConfig(
    duration: slow,
    curve: snapOut,
  );

  static const AnimationConfig slideDrawer = AnimationConfig(
    duration: medium,
    curve: slide,
  );

  static const AnimationConfig pageTransition = AnimationConfig(
    duration: slow,
    curve: slide,
  );

  static const AnimationConfig toastAnimation = AnimationConfig(
    duration: toast,
    curve: snapOut,
  );
}

// Animation Configuration Helper
class AnimationConfig {
  final Duration duration;
  final Curve curve;

  const AnimationConfig({
    required this.duration,
    required this.curve,
  });
}
