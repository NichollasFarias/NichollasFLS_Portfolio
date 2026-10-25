import 'dart:async';
import 'package:flutter/material.dart';

/// Runs once when the element enters the viewport. No idle animation loop.
class Reveal extends StatefulWidget {
  final ScrollController scroll;
  final Widget child;
  final int order;
  const Reveal({
    super.key,
    required this.scroll,
    required this.child,
    this.order = 0,
  });
  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  bool visible = false;
  bool scheduled = false;
  Timer? delay;
  @override
  void initState() {
    super.initState();
    widget.scroll.addListener(check);
    WidgetsBinding.instance.addPostFrameCallback((_) => check());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      visible = true;
    }
  }

  void check() {
    if (!mounted || visible || scheduled) {
      return;
    }
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) {
      return;
    }
    final y = box.localToGlobal(Offset.zero).dy;
    if (y < MediaQuery.sizeOf(context).height + 30 && y + box.size.height > 0) {
      scheduled = true;
      delay = Timer(Duration(milliseconds: (widget.order % 4) * 45), () {
        if (mounted) {
          setState(() => visible = true);
        }
      });
    }
  }

  @override
  void dispose() {
    delay?.cancel();
    widget.scroll.removeListener(check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    final show = visible || reduced;
    return RepaintBoundary(
      child: AnimatedSlide(
        offset: show ? Offset.zero : const Offset(0, .035),
        duration: reduced ? Duration.zero : const Duration(milliseconds: 480),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: show ? 1 : 0,
          duration: reduced ? Duration.zero : const Duration(milliseconds: 420),
          child: widget.child,
        ),
      ),
    );
  }
}
