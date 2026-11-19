import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// Decorative "orbit" motif from the brand direction: concentric orbits and
/// a single eight-pointed star, drawn as thin lines at low opacity.
///
/// Purely decorative (excluded from semantics) and drawn towards the
/// reading-end edge, so it mirrors with the layout direction.
class OrbitMotif extends StatelessWidget {
  const OrbitMotif({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(
      painter: _OrbitPainter(
        color: color,
        alignEnd: Directionality.of(context) == TextDirection.ltr,
      ),
      size: Size.infinite,
    ),
  );
}

class _OrbitPainter extends CustomPainter {
  _OrbitPainter({required this.color, required this.alignEnd});

  final Color color;

  /// True when the end edge is on the right (LTR).
  final bool alignEnd;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      alignEnd ? size.width * 0.92 : size.width * 0.08,
      size.height * 0.18,
    );
    final unit = math.max(size.width, size.height) * 0.22;

    final orbit = Paint()
      ..color = color.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 1; i <= 4; i++) {
      canvas.drawCircle(center, unit * i * 0.62, orbit);
    }

    // Eight-pointed star: two squares rotated by 45°.
    final star = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final r = unit * 0.42;
    for (final rotation in [0.0, math.pi / 4]) {
      final path = Path();
      for (var k = 0; k < 4; k++) {
        final a = rotation + k * math.pi / 2 + math.pi / 4;
        final p = center + Offset(math.cos(a) * r, math.sin(a) * r);
        k == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      path.close();
      canvas.drawPath(path, star);
    }

    // A small "planet" on the second orbit.
    final dot = Paint()..color = color.withValues(alpha: 0.6);
    final angle = alignEnd ? math.pi * 0.72 : math.pi * 0.28;
    canvas.drawCircle(
      center + Offset(math.cos(angle), math.sin(angle)) * unit * 1.24,
      3,
      dot,
    );
  }

  @override
  bool shouldRepaint(_OrbitPainter old) =>
      old.color != color || old.alignEnd != alignEnd;
}
