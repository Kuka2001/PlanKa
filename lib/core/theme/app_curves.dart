import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Кривые анимации в стиле iOS (Spring-like)
class AppCurves {
  AppCurves._();
  
  // Быстрая и упругая анимация (имитация spring physics)
  static const Curve spring = _SpringCurve();
  
  // Плавное затухание
  static const Curve easeInOutCubic = Cubic(0.65, 0.0, 0.35, 1.0);
  
  // Быстрое появление с отскоком
  static const Curve easeOutBack = Cubic(0.34, 1.56, 0.64, 1.0);
}

class _SpringCurve extends Curve {
  const _SpringCurve();
  
  @override
  double transform(double t) {
    if (t == 0 || t == 1) return t;
    // Имитация пружины: быстрое начало, мягкое торможение с небольшим отскоком
    return 1 - math.pow(1 - t, 3).toDouble() * math.cos(t * 9 * math.pi);
  }
}
