import 'package:flutter/material.dart';

Route buildRpgRoute(Widget page, {TransitionType type = TransitionType.fade}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (type) {
        case TransitionType.fade:
          return FadeTransition(opacity: animation, child: child);

        case TransitionType.slide:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child,
          );

        case TransitionType.scale:
          return ScaleTransition(
            scale: Tween<double>(begin: 0.7, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutExpo),
            ),
            child: child,
          );

        case TransitionType.rotate:
          return RotationTransition(
            turns: Tween(begin: 1.0, end: 0.0).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );

        default:
          return FadeTransition(opacity: animation, child: child);
      }
    },
    transitionDuration: const Duration(milliseconds: 800),
  );
}

enum TransitionType { fade, slide, scale, rotate }
