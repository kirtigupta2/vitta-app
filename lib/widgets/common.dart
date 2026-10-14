import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Cross-fade page transition used between the Vitta screens.
Route<T> fadeRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

/// Shown for taps on things the Figma file does not design a screen for.
void showProto(BuildContext context, String what) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text("$what isn't part of this prototype"),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
}

/// Loads an exported Figma image from assets/. Until you add the file, a
/// tinted placeholder is shown so the app still runs.
class AssetOrPlaceholder extends StatelessWidget {
  const AssetOrPlaceholder(
    this.path, {
    super.key,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.radius = 8,
    this.icon = Icons.image_outlined,
    this.color = const Color(0x1A084BA4),
    this.iconColor = const Color(0x66084BA4),
  });

  final String path;
  final double width;
  final double height;
  final BoxFit fit;
  final Alignment alignment;
  final double radius;
  final IconData icon;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (_, __, ___) => DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Center(
            child: Icon(icon, size: width * 0.5, color: iconColor),
          ),
        ),
      ),
    );
  }
}

/// Soft blue / peach background used on the Vitta screens (A04, A05).
class VittaBackground extends StatelessWidget {
  const VittaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: VColors.screenBg),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-1.0, -0.15),
              radius: 0.9,
              colors: [Color(0x403476AE), Color(0x003476AE)],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(1.0, 0.95),
              radius: 0.95,
              colors: [Color(0x40FC8742), Color(0x1AF5A475), Color(0x00F5A475)],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

/// "How can I help you?" input. Empty -> mic, text -> send,
/// whitespace only -> disabled send (per the Figma component notes).
class SearchDock extends StatefulWidget {
  const SearchDock({super.key});

  @override
  State<SearchDock> createState() => _SearchDockState();
}

class _SearchDockState extends State<SearchDock> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    if (_controller.text.trim().isEmpty) return;
    _controller.clear();
    FocusScope.of(context).unfocus();
    setState(() {});
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Message sent (demo)'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
  }

  Widget _trailing() {
    final text = _controller.text;
    if (text.isEmpty) {
      return IconButton(
        tooltip: 'Dictate',
        onPressed: () => showProto(context, 'Dictation'),
        icon: const Icon(Icons.mic_none, size: 22, color: VColors.textSecondary),
      );
    }
    final canSend = text.trim().isNotEmpty;
    return IconButton(
      tooltip: canSend ? 'Send message' : 'Send message, unavailable',
      onPressed: canSend ? _send : null,
      icon: Icon(
        Icons.send_rounded,
        size: 22,
        color: canSend ? VColors.primary : const Color(0xFFB8C2CF),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 12, right: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: VShadows.floating,
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 22, color: VColors.textSecondary),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _send(),
              textInputAction: TextInputAction.send,
              style: vText(16, FontWeight.w500, VColors.textPrimary),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                hintText: 'How can I help you?',
                hintStyle: vText(
                  16,
                  FontWeight.w500,
                  const Color(0xB36B7280),
                  letterSpacing: -0.32,
                ),
              ),
            ),
          ),
          SizedBox(width: 44, height: 44, child: _trailing()),
        ],
      ),
    );
  }
}

/// Bottom search area with the soft fade behind it (A04, A05).
/// Must be a direct child of a Stack.
class VittaDock extends StatelessWidget {
  const VittaDock({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(17.5, 38, 17.5, bottom + 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x00F4F8FC), Color(0xE6F4F8FC), Color(0xF7F4F8FC)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: const SearchDock(),
      ),
    );
  }
}

/// Header with back, Vitta brand and search / minimize / close.
class VittaTopBar extends StatelessWidget {
  const VittaTopBar({super.key, this.serifBrand = false});

  /// A05 uses a serif wordmark in Figma (DM Serif Text); A04 uses Roboto.
  final bool serifBrand;

  Widget _btn(BuildContext context, IconData icon, String tip, VoidCallback onTap) {
    return IconButton(
      tooltip: tip,
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, size: 22, color: VColors.textPrimary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _btn(context, Icons.chevron_left, 'Back',
            () => Navigator.of(context).maybePop()),
        const Icon(Icons.auto_awesome, size: 18, color: VColors.primary),
        const SizedBox(width: 6),
        Text(
          'Vitta',
          style: TextStyle(
            fontFamily: serifBrand ? 'serif' : null,
            fontSize: 20,
            height: 1.4,
            letterSpacing: -0.18,
            color: VColors.primary,
          ),
        ),
        const Spacer(),
        _btn(context, Icons.search, 'Search', () => showProto(context, 'Search')),
        _btn(context, Icons.picture_in_picture_alt_outlined, 'Minimize',
            () => showProto(context, 'Minimize')),
        _btn(context, Icons.close, 'Close',
            () => Navigator.of(context).popUntil((r) => r.isFirst)),
      ],
    );
  }
}
