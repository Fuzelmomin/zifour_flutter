import 'package:flutter/material.dart';

/// Global Animation Class
/// This class provides multiple types of animations that can be reused across the app
class AppAnimations {
  // Private constructor to prevent instantiation
  AppAnimations._();

  /// Fade In Animation
  /// Creates a fade-in animation that gradually increases opacity from 0 to 1
  static Widget fadeIn({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Slide In From Left Animation
  /// Creates a slide animation that moves the widget from left to its final position
  static Widget slideInFromLeft({
    required Widget child,
    required Animation<double> animation,
    Curve curve = Curves.easeOut,
    double offset = 50.0,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(-offset, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: curve)),
      child: child,
    );
  }

  /// Slide In From Right Animation
  /// Creates a slide animation that moves the widget from right to its final position
  static Widget slideInFromRight({
    required Widget child,
    required Animation<double> animation,
    Curve curve = Curves.easeOut,
    double offset = 50.0,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(offset, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: curve)),
      child: child,
    );
  }

  /// Slide In From Top Animation
  /// Creates a slide animation that moves the widget from top to its final position
  static Widget slideInFromTop({
    required Widget child,
    required Animation<double> animation,
    Curve curve = Curves.easeOut,
    double offset = 50.0,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, -offset),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: curve)),
      child: child,
    );
  }

  /// Slide In From Bottom Animation
  /// Creates a slide animation that moves the widget from bottom to its final position
  static Widget slideInFromBottom({
    required Widget child,
    required Animation<double> animation,
    Curve curve = Curves.easeOut,
    double offset = 50.0,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, offset),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: curve)),
      child: child,
    );
  }

  /// Scale Animation
  /// Creates a scale animation that grows or shrinks the widget
  static Widget scale({
    required Widget child,
    required Animation<double> animation,
    Curve curve = Curves.easeOut,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: begin,
        end: end,
      ).animate(CurvedAnimation(parent: animation, curve: curve)),
      child: child,
    );
  }

  /// Bounce Animation
  /// Creates a bounce animation with an elastic effect
  static Widget bounce({
    required Widget child,
    required Animation<double> animation,
    Curve curve = Curves.elasticOut,
  }) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: curve)),
      child: child,
    );
  }

  /// Rotation Animation
  /// Creates a rotation animation that rotates the widget
  static Widget rotate({
    required Widget child,
    required Animation<double> animation,
    Curve curve = Curves.easeInOut,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return RotationTransition(
      turns: Tween<double>(
        begin: begin,
        end: end,
      ).animate(CurvedAnimation(parent: animation, curve: curve)),
      child: child,
    );
  }

  /// Combined Fade and Slide Animation
  /// Combines fade and slide animations for a more complex effect
  static Widget fadeSlideIn({
    required Widget child,
    required Animation<double> animation,
    Curve curve = Curves.easeOut,
    Offset slideOffset = const Offset(0, 30),
  }) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: slideOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: curve)),
        child: child,
      ),
    );
  }

  /// Combined Fade and Scale Animation
  /// Combines fade and scale animations for a pop-in effect
  static Widget fadeScaleIn({
    required Widget child,
    required Animation<double> animation,
    Curve curve = Curves.easeOut,
    double scaleBegin = 0.8,
  }) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(
          begin: scaleBegin,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: curve)),
        child: child,
      ),
    );
  }

  /// Staggered Animation Builder
  /// Creates a widget that animates with a delay (staggered effect)
  /// Note: duration should be set on the AnimationController, not here
  static Widget staggered({
    required Widget child,
    required Animation<double> animation,
    required int index,
    Curve curve = Curves.easeOut,
    int staggerDelay = 100,
    int totalDuration = 500,
  }) {
    final delayedAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(
          (index * staggerDelay) / totalDuration,
          1.0,
          curve: curve,
        ),
      ),
    );

    return FadeTransition(
      opacity: delayedAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 30),
          end: Offset.zero,
        ).animate(delayedAnimation),
        child: child,
      ),
    );
  }

  /// Pulse Animation
  /// Creates a pulsing effect that repeatedly scales the widget
  static Widget pulse({
    required Widget child,
    required Animation<double> animation,
    Curve curve = Curves.easeInOut,
  }) {
    return ScaleTransition(
      scale: TweenSequence<double>([
        TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.1), weight: 1),
        TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 1.0), weight: 1),
      ]).animate(CurvedAnimation(parent: animation, curve: curve)),
      child: child,
    );
  }

  /// Shake Animation
  /// Creates a shake effect that moves the widget horizontally
  static Widget shake({
    required Widget child,
    required Animation<double> animation,
    Curve curve = Curves.easeInOut,
    double shakeAmount = 10.0,
  }) {
    return SlideTransition(
      position: TweenSequence<Offset>([
        TweenSequenceItem(tween: Tween<Offset>(begin: Offset.zero, end: Offset(-shakeAmount, 0)), weight: 1),
        TweenSequenceItem(tween: Tween<Offset>(begin: Offset(-shakeAmount, 0), end: Offset(shakeAmount, 0)), weight: 1),
        TweenSequenceItem(tween: Tween<Offset>(begin: Offset(shakeAmount, 0), end: Offset(-shakeAmount, 0)), weight: 1),
        TweenSequenceItem(tween: Tween<Offset>(begin: Offset(-shakeAmount, 0), end: Offset.zero), weight: 1),
      ]).animate(CurvedAnimation(parent: animation, curve: curve)),
      child: child,
    );
  }
}

