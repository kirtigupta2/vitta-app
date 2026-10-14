import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';
import 'theme/tokens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const VittaApp());
}

class VittaApp extends StatelessWidget {
  const VittaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vitta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: VColors.primary,
          primary: VColors.primary,
        ),
        scaffoldBackgroundColor: VColors.screenBg,
      ),
      builder: _frame,
      home: const HomeScreen(),
    );
  }

  // The Figma frames are 393 x 852 and assume a 54 px status bar. This keeps
  // that layout on every phone, and on the web it shows the app in a phone-
  // sized frame so the Chrome preview matches the design.
  static Widget _frame(BuildContext context, Widget? child) {
    final media = MediaQuery.of(context);
    final padding = media.padding.copyWith(top: math.max(media.padding.top, 54));
    final app = MediaQuery(
      data: media.copyWith(padding: padding),
      child: child ?? const SizedBox.shrink(),
    );
    if (!kIsWeb) return app;

    final height = math.min(media.size.height, 852.0);
    return ColoredBox(
      color: const Color(0xFF1B1F27),
      child: Center(
        child: ClipRect(
          child: SizedBox(
            width: 393,
            height: height,
            child: MediaQuery(
              data: media.copyWith(
                size: Size(393, height),
                padding: padding,
              ),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
