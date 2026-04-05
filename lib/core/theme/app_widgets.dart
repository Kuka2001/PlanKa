import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_curves.dart';

/// Glassmorphism карточка - основной UI элемент
class GlassCard extends StatefulWidget {
  final Widget child;
  final double padding;
  final double borderRadius;
  final Color? color;
  final double opacity;
  final VoidCallback? onTap;
  final bool animateOnTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = 20,
    this.borderRadius = 20,
    this.color,
    this.opacity = 0.15,
    this.onTap,
    this.animateOnTap = true,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: AppCurves.spring),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.animateOnTap && widget.onTap != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.animateOnTap && widget.onTap != null) {
      _controller.reverse();
      // Вызываем onTap только один раз - в onTapUp
      widget.onTap!();
    }
  }

  void _handleTapCancel() {
    if (widget.animateOnTap && widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.all(widget.padding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                (widget.color ?? AppColors.surfaceLight).withOpacity(widget.opacity),
                (widget.color ?? AppColors.surfaceLight).withOpacity(widget.opacity * 0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: AppColors.glassBorder.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: widget.child,
        ),
      ),
    );

    if (widget.onTap != null && widget.animateOnTap) {
      return GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: (_) => _handleTapCancel(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: card,
        ),
      );
    }

    return GestureDetector(onTap: widget.onTap, child: card);
  }
}

/// Анимированный счетчик чисел
class AnimatedNumber extends StatefulWidget {
  final double value;
  final String prefix;
  final String suffix;
  final TextStyle? style;
  final Duration duration;
  final int decimals;

  const AnimatedNumber({
    super.key,
    required this.value,
    this.prefix = '',
    this.suffix = '',
    this.style,
    this.duration = const Duration(milliseconds: 800),
    this.decimals = 0,
  });

  @override
  State<AnimatedNumber> createState() => _AnimatedNumberState();
}

class _AnimatedNumberState extends State<AnimatedNumber>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _displayValue = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _displayValue = widget.value;
    _isInitialized = true;
  }

  @override
  void didUpdateWidget(AnimatedNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && mounted) {
      _startAnimation(oldWidget.value, widget.value);
    }
  }

  void _startAnimation(double from, double to) {
    _controller.dispose();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: from, end: to).animate(
      CurvedAnimation(parent: _controller, curve: AppCurves.spring),
    );
    _animation.addListener(() {
      if (mounted) {
        setState(() => _displayValue = _animation.value);
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Защита от NaN и бесконечности
    final safeValue = _displayValue.isFinite ? _displayValue : 0.0;
    final formatted = safeValue.toStringAsFixed(widget.decimals);
    return Text(
      '${widget.prefix}$formatted${widget.suffix}',
      style: widget.style,
    );
  }
}

/// Пульсирующая анимация для важных элементов
class PulsingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const PulsingWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.minScale = 0.95,
    this.maxScale = 1.0,
  });

  @override
  State<PulsingWidget> createState() => _PulsingWidgetState();
}

class _PulsingWidgetState extends State<PulsingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: widget.minScale, end: widget.maxScale)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(PulsingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.minScale != widget.minScale || 
        oldWidget.maxScale != widget.maxScale ||
        oldWidget.duration != widget.duration) {
      _controller.dispose();
      _controller = AnimationController(duration: widget.duration, vsync: this);
      _animation = Tween<double>(begin: widget.minScale, end: widget.maxScale)
          .animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Slide анимация для появления элементов списка
class SlideInList extends StatefulWidget {
  final List<Widget> children;
  final Duration baseDuration;
  final Duration staggerDelay;
  final double startOffset; // Откуда начинается анимация (по умолчанию 50px снизу)

  const SlideInList({
    super.key,
    required this.children,
    this.baseDuration = const Duration(milliseconds: 400),
    this.staggerDelay = const Duration(milliseconds: 80),
    this.startOffset = 50.0,
  });

  @override
  State<SlideInList> createState() => _SlideInListState();
}

class _SlideInListState extends State<SlideInList> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _controllers = List.generate(widget.children.length, (index) {
      final controller = AnimationController(
        duration: widget.baseDuration + (widget.staggerDelay * index),
        vsync: this,
      );
      final animation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: AppCurves.easeOutBack),
      );
      controller.forward().then((_) {
        // Анимация завершена
      });
      return controller;
    });
    
    _animations = _controllers.map((c) {
      return Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: c, curve: AppCurves.easeOutBack),
      );
    }).toList();
  }

  @override
  void didUpdateWidget(SlideInList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      // Очистка старых контроллеров
      for (final controller in _controllers) {
        controller.dispose();
      }
      _initAnimations();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            final offset = _animations[index].value;
            return Transform.translate(
              offset: Offset(0, widget.startOffset * offset),
              child: Opacity(
                opacity: 1 - offset,
                child: child,
              ),
            );
          },
          child: widget.children[index],
        );
      },
    );
  }
}

/// Прогресс бар с анимацией заполнения
class AnimatedProgressBar extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final Color? color;
  final double height;
  final Duration duration;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.color,
    this.height = 8,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentProgress = 0;

  @override
  void initState() {
    super.initState();
    _currentProgress = widget.progress.clamp(0.0, 1.0);
    _initAnimation(widget.progress, widget.progress);
  }

  void _initAnimation(double from, double to) {
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: from, end: to.clamp(0.0, 1.0)).animate(
      CurvedAnimation(parent: _controller, curve: AppCurves.spring),
    );
    _animation.addListener(() {
      if (mounted) {
        setState(() => _currentProgress = _animation.value);
      }
    });
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress && mounted) {
      _controller.dispose();
      _initAnimation(oldWidget.progress.clamp(0.0, 1.0), widget.progress);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Защита от NaN и некорректных значений
    final safeProgress = _currentProgress.isFinite 
        ? _currentProgress.clamp(0.0, 1.0) 
        : 0.0;
        
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.height / 2),
      child: Container(
        height: widget.height,
        color: AppColors.surfaceLight,
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: safeProgress,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.color ?? AppColors.primary,
                  (widget.color ?? AppColors.primary).withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
          ),
        ),
      ),
    );
  }
}
