import 'package:flutter/material.dart';

// ─── Staggered Fade + Slide in ────────────────────────────────────────────────
// index * 75ms delay → жагсаалт ачаалах үед бага багаар уусч орж ирнэ
// Шинэ item нэмэхэд index-т тохирсон delay-тай анимажна

class FadeSlideItem extends StatefulWidget {
  final Widget child;
  final int index;

  const FadeSlideItem({
    super.key,
    required this.child,
    this.index = 0,
  });

  @override
  State<FadeSlideItem> createState() => _FadeSlideItemState();
}

class _FadeSlideItemState extends State<FadeSlideItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(
      Duration(milliseconds: widget.index * 75),
      () {
        if (mounted) _ctrl.forward();
      },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _opacity,
        child: SlideTransition(position: _slide, child: widget.child),
      );
}

// ─── Heartbeat Scale Animation ────────────────────────────────────────────────
// Зүрхний цохилт шиг: хоёр товших → урт амрах → давтах

class HeartbeatWidget extends StatefulWidget {
  final Widget child;

  const HeartbeatWidget({super.key, required this.child});

  @override
  State<HeartbeatWidget> createState() => _HeartbeatWidgetState();
}

class _HeartbeatWidgetState extends State<HeartbeatWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Хоёр удаа товших (P болон QRS долгион), дараа нь урт амрах
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.008), weight: 7),
      TweenSequenceItem(tween: Tween(begin: 1.008, end: 0.997), weight: 6),
      TweenSequenceItem(tween: Tween(begin: 0.997, end: 1.018), weight: 9),
      TweenSequenceItem(tween: Tween(begin: 1.018, end: 1.0), weight: 11),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 67),
    ]).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: widget.child,
      );
}
