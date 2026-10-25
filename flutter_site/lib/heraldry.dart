import 'package:flutter/material.dart';
import 'app.dart';

Path shieldPath(Size size, [double inset = 0]) {
  final w = size.width - inset * 2;
  final h = size.height - inset * 2;
  final pts = <Offset>[
    Offset(.08 * w, 0),
    Offset(.92 * w, 0),
    Offset(w, .075 * h),
    Offset(w, .69 * h),
    Offset(.93 * w, .83 * h),
    Offset(.5 * w, h),
    Offset(.07 * w, .83 * h),
    Offset(0, .69 * h),
    Offset(0, .075 * h),
  ];
  return Path()
    ..addPolygon(pts.map((v) => v + Offset(inset, inset)).toList(), true);
}

class ShieldClipper extends CustomClipper<Path> {
  const ShieldClipper();
  @override
  Path getClip(Size size) => shieldPath(size);
  @override
  bool shouldReclip(ShieldClipper oldClipper) => false;
}

class HeraldicFrame extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [silver, Color(0xFF514260), ice, Color(0xFF514260)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(shieldPath(size, 2), stroke);
    canvas.drawPath(
      shieldPath(size, 13),
      stroke
        ..color = line
        ..shader = null,
    );
    final p = Paint()
      ..color = ice.withValues(alpha: .7)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (final right in [false, true]) {
      final x = right ? size.width - 6 : 6.0;
      final inward = right ? -1.0 : 1.0;
      canvas.drawPath(
        Path()
          ..moveTo(x, size.height * .23)
          ..lineTo(x + inward * 16, size.height * .26)
          ..lineTo(x + inward * 16, size.height * .42)
          ..lineTo(x, size.height * .45),
        p,
      );
      canvas.drawCircle(Offset(x, size.height * .23), 3, p);
    }
    final center = Offset(size.width * .5, size.height - 4);
    canvas.drawPath(
      Path()..addPolygon([
        center + const Offset(0, -12),
        center + const Offset(7, -6),
        center,
        center + const Offset(-7, -6),
      ], true),
      Paint()..color = ice,
    );
  }

  @override
  bool shouldRepaint(HeraldicFrame oldDelegate) => false;
}

class Ornament extends StatelessWidget {
  const Ornament({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 32,
    width: double.infinity,
    child: CustomPaint(painter: _OrnamentPainter()),
  );
}

class _OrnamentPainter extends CustomPainter {
  const _OrnamentPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.width / 2, y = size.height / 2;
    final p = Paint()
      ..color = line
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, y), Offset(center - 44, y), p);
    canvas.drawLine(Offset(center + 44, y), Offset(size.width, y), p);
    for (final side in [-1, 1]) {
      canvas.drawPath(
        Path()
          ..moveTo(center + side * 40, y)
          ..lineTo(center + side * 24, y - 5)
          ..lineTo(center + side * 15, y)
          ..lineTo(center + side * 24, y + 5)
          ..close(),
        p..color = silver.withValues(alpha: .45),
      );
    }
    canvas.drawPath(
      Path()..addPolygon([
        Offset(center, y - 10),
        Offset(center + 7, y),
        Offset(center, y + 10),
        Offset(center - 7, y),
      ], true),
      p..color = ice,
    );
    canvas.drawLine(
      Offset(center, y - 14),
      Offset(center, y + 14),
      p..color = violet,
    );
  }

  @override
  bool shouldRepaint(_OrnamentPainter oldDelegate) => false;
}
