import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The glowing ring that appears where you long-press a card (A02).
/// Four soft strokes rotate at different speeds, like the Figma "Score Gauge".
class VittaOrb extends StatefulWidget {
  const VittaOrb({super.key, this.size = 118});

  final double size;

  @override
  State<VittaOrb> createState() => _VittaOrbState();
}

class _VittaOrbState extends State<VittaOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Uses the ring image from Figma when it is in assets/images/ring.png and
    // falls back to a painted ring otherwise. The image has a soft glow
    // around the ring, so it is drawn larger than the box and not clipped.
    final fallback = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        size: Size.square(widget.size),
        painter: _OrbPainter(_controller.value),
      ),
    );
    return SizedBox.square(
      dimension: widget.size,
      child: OverflowBox(
        minWidth: 0,
        minHeight: 0,
        maxWidth: widget.size * 1.45,
        maxHeight: widget.size * 1.45,
        child: RotationTransition(
          turns: _controller,
          child: Image.asset(
            'assets/images/ring.png',
            width: widget.size * 1.45,
            height: widget.size * 1.45,
            errorBuilder: (_, __, ___) => fallback,
          ),
        ),
      ),
    );
  }
}

class _OrbPainter extends CustomPainter {
  _OrbPainter(this.t);

  final double t;

  static const _blue = Color(0xFF4F8FFF);
  static const _pink = Color(0xFFF58FB8);
  static const _orange = Color(0xFFFC8742);

  SweepGradient _sweep(double offset) {
    return SweepGradient(
      colors: const [_blue, _pink, _orange, _blue],
      transform: GradientRotation(2 * math.pi * t + offset),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 14;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
      ..shader = _sweep(0).createShader(rect);
    canvas.drawCircle(center, radius, glow);

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..shader = _sweep(math.pi).createShader(rect);
    canvas.drawCircle(center, radius, ring);

    final inner = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..shader = _sweep(math.pi / 2).createShader(rect);
    canvas.drawCircle(center, radius - 6, inner);

    final outer = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..shader = _sweep(-math.pi / 2).createShader(rect);
    canvas.drawCircle(center, radius + 6, outer);
  }

  @override
  bool shouldRepaint(covariant _OrbPainter old) => old.t != t;
}
