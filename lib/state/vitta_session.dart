import 'dart:async';

import 'package:flutter/foundation.dart';

/// What the minimized Vitta pill on Home is showing.
enum MiniStatus { building, ready }

/// Tiny app-wide state for the minimized Vitta agent.
class VittaSession {
  VittaSession._();

  /// null = not minimized (no pill on Home).
  static final ValueNotifier<MiniStatus?> mini = ValueNotifier<MiniStatus?>(null);

  static Timer? _timer;

  /// Called when the user taps Minimize on the build (A04) or intro (A05) screen.
  static void minimize(MiniStatus status) {
    _timer?.cancel();
    mini.value = status;
    if (status == MiniStatus.building) {
      // The agent keeps working in the background, then reports back.
      _timer = Timer(const Duration(seconds: 4), () {
        if (mini.value == MiniStatus.building) mini.value = MiniStatus.ready;
      });
    }
  }

  static void clear() {
    _timer?.cancel();
    mini.value = null;
  }
}
