import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/common.dart';
import '../widgets/orb.dart';
import 'vitta_build_screen.dart';

/// Wrap any card with this to get "long press to ask Vitta" (A02 -> A03).
class AskVittaCard extends StatelessWidget {
  const AskVittaCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressStart: (details) {
          HapticFeedback.mediumImpact();
          final box = context.findRenderObject() as RenderBox;
          // Measure relative to the app's own area, so it stays correct when
          // the app is shown in a phone-sized frame on the web.
          final area = Navigator.of(context).context.findRenderObject() as RenderBox;
          final rect = box.localToGlobal(Offset.zero, ancestor: area) & box.size;
          final press = area.globalToLocal(details.globalPosition);
          Navigator.of(context).push(
            PageRouteBuilder<void>(
              opaque: false,
              transitionDuration: const Duration(milliseconds: 200),
              reverseTransitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (_, __, ___) => VittaOverlay(
                cardRect: rect,
                pressPoint: press,
                card: child,
              ),
              transitionsBuilder: (_, animation, __, page) =>
                  FadeTransition(opacity: animation, child: page),
            ),
          );
        },
        child: child,
      ),
    );
  }
}

/// A02: glowing ring where you pressed.
/// A03: screen dims, the card lifts above it, and suggestion chips appear.
class VittaOverlay extends StatefulWidget {
  const VittaOverlay({
    super.key,
    required this.cardRect,
    required this.pressPoint,
    required this.card,
  });

  final Rect cardRect;
  final Offset pressPoint;
  final Widget card;

  @override
  State<VittaOverlay> createState() => _VittaOverlayState();
}

class _VittaOverlayState extends State<VittaOverlay> {
  static const _suggestions = [
    'Best fit for me',
    'Why am I seeing this?',
    'How can I apply for this?',
  ];

  bool _showSuggestions = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      HapticFeedback.selectionClick();
      setState(() => _showSuggestions = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _openVitta() {
    Navigator.of(context).pushReplacement(fadeRoute(const VittaBuildScreen()));
  }

  Widget _chip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: _openVitta,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFFFDF0E9), Color(0xFFDEE9F2)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x29000000),
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: vText(12, FontWeight.w400, VColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    const orbSize = 113.0; // 5 px smaller than before
    final orbLeft = widget.pressPoint.dx - orbSize / 2;
    final orbTop = widget.pressPoint.dy - orbSize / 2;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Scrim: transparent while the ring shows, dims for suggestions.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color: _showSuggestions
                    ? const Color(0x990E1A2B)
                    : const Color(0x000E1A2B),
              ),
            ),
          ),

          // The pressed card, lifted above the scrim.
          Positioned.fromRect(
            rect: widget.cardRect,
            child: IgnorePointer(child: widget.card),
          ),

          // Glowing ring under the finger.
          Positioned(
            left: orbLeft,
            top: orbTop,
            width: orbSize,
            height: orbSize,
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: _showSuggestions ? 0 : 1,
                duration: const Duration(milliseconds: 250),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.6, end: 1.0),
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) =>
                      Transform.scale(scale: value, child: child),
                  child: const VittaOrb(size: orbSize),
                ),
              ),
            ),
          ),

          // Bottom nav with Vitta selected, shown with the suggestions.
          Positioned(
            left: 17.5,
            right: 17.5,
            bottom: 16 + bottomPad,
            child: IgnorePointer(
              ignoring: !_showSuggestions,
              child: AnimatedOpacity(
                opacity: _showSuggestions ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: VittaBottomNav(
                  selected: 4,
                  onTap: (i) {
                    if (i == 0) {
                      Navigator.of(context).pop();
                    } else if (i != 4) {
                      showProto(context, VittaBottomNav.tabs[i].label);
                    }
                  },
                ),
              ),
            ),
          ),

          // Suggestion chips + search input.
          Positioned(
            left: 0,
            right: 0,
            bottom: 86 + bottomPad,
            child: IgnorePointer(
              ignoring: !_showSuggestions,
              child: AnimatedOpacity(
                opacity: _showSuggestions ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: AnimatedSlide(
                  offset: _showSuggestions ? Offset.zero : const Offset(0, 0.25),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 52,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(17.5, 4, 16, 4),
                          children: [for (final s in _suggestions) _chip(s)],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 17.5),
                        child: SearchDock(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
