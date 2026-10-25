import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'app.dart';

Widget copy(
  String value, {
  double size = 16,
  Color color = silver,
  FontWeight weight = FontWeight.normal,
}) => Text(
  value,
  style: TextStyle(
    fontSize: size,
    height: 1.6,
    color: color,
    fontWeight: weight,
  ),
);
Widget heading(String value, {double size = 48}) => Text(
  value,
  style: TextStyle(
    fontSize: size,
    height: 1.12,
    letterSpacing: -1.5,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  ),
);
Widget eyebrow(String value) => Padding(
  padding: const EdgeInsets.only(bottom: 22),
  child: copy(
    value.toUpperCase(),
    size: 11,
    color: ice,
    weight: FontWeight.w600,
  ),
);
Widget gap([double height = 24]) => SizedBox(height: height);
Widget action(String label, VoidCallback onTap, {bool secondary = false}) =>
    secondary
    ? OutlinedButton(onPressed: onTap, child: Text('$label  ↗'))
    : FilledButton(onPressed: onTap, child: Text('$label  ↗'));
Widget tags(List<String> values) => Wrap(
  spacing: 8,
  runSpacing: 8,
  children: values
      .map(
        (v) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: line),
            borderRadius: BorderRadius.circular(5),
          ),
          child: copy(v, size: 11),
        ),
      )
      .toList(),
);
Widget split(Widget first, Widget second, {int left = 6, int right = 5}) =>
    LayoutBuilder(
      builder: (_, c) => c.maxWidth < 760
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [first, gap(36), second],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: left, child: first),
                const SizedBox(width: 64),
                Expanded(flex: right, child: second),
              ],
            ),
    );

class HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final String label;
  const HoverCard({
    super.key,
    required this.child,
    required this.onTap,
    required this.label,
  });
  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool hover = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => hover = true),
    onExit: (_) => setState(() => hover = false),
    child: AnimatedContainer(
      duration: MediaQuery.of(context).disableAnimations
          ? Duration.zero
          : const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: hover ? violet : line),
        boxShadow: hover
            ? [BoxShadow(color: violet.withValues(alpha: .12), blurRadius: 24)]
            : [],
      ),
      child: Semantics(
        button: true,
        label: widget.label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.onTap,
            child: widget.child,
          ),
        ),
      ),
    ),
  );
}

class CircuitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [violet.withValues(alpha: .25), ink.withValues(alpha: 0)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, glow);
    final p = Paint()
      ..color = line
      ..strokeWidth = .8;
    for (double x = 0; x < size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
    p
      ..color = ice.withValues(alpha: .7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()
      ..moveTo(0, size.height * .75)
      ..lineTo(12, size.height * .75)
      ..lineTo(12, 40)
      ..lineTo(40, 12)
      ..lineTo(size.width * .7, 12);
    canvas.drawPath(path, p);
    canvas.drawCircle(Offset(size.width * .7, 12), 4, p);
    final length = math.min(size.width, size.height) * .22;
    canvas.drawLine(
      Offset(size.width - 8, size.height - length),
      Offset(size.width - 8, size.height - 8),
      p,
    );
    canvas.drawLine(
      Offset(size.width - length, size.height - 8),
      Offset(size.width - 8, size.height - 8),
      p,
    );
  }

  @override
  bool shouldRepaint(CircuitPainter oldDelegate) => false;
}
