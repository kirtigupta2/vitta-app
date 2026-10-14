import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/vitta_session.dart';
import '../widgets/agent_log.dart';
import '../widgets/common.dart';
import 'card_intro_screen.dart';

/// A04: Vitta is "building" a recommendation. Steps run one after another,
/// then the app moves on to the card intro (A05).
class VittaBuildScreen extends StatefulWidget {
  const VittaBuildScreen({super.key});

  @override
  State<VittaBuildScreen> createState() => _VittaBuildScreenState();
}

class _VittaBuildScreenState extends State<VittaBuildScreen> {
  static const _running = [
    'Analyzing spending behavior',
    'Exploring credit card savings opportunities',
    'Evaluating eligibility signals',
    'Building personalized application journey',
    'Preparing recommendations and next steps',
  ];

  static const _finished = [
    'Analyzed spending behavior',
    'Explored credit card savings opportunities',
    'Evaluated eligibility signals',
    'Built personalized application journey',
    'Prepared recommendations and next steps',
  ];

  int _current = 0;
  bool _expanded = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1100), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _current++);
      if (_current >= _running.length) {
        t.cancel();
        _timer = Timer(const Duration(milliseconds: 900), () {
          if (!mounted) return;
          Navigator.of(context)
              .pushReplacement(fadeRoute(const CardIntroScreen()));
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).padding;

    final rows = <Widget>[
      for (var i = 0; i < _running.length; i++)
        if (i <= _current)
          LogRow(
            text: i < _current ? _finished[i] : _running[i],
            done: i < _current,
          ),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            const Positioned.fill(child: VittaBackground()),
            Positioned(
              top: pad.top + 12,
              left: 16,
              right: 16,
              child: const VittaTopBar(minimizeStatus: MiniStatus.building),
            ),
            Positioned(
              top: pad.top + 68,
              left: 16,
              right: 16,
              child: AgentLogCard(
                title: 'Building your personalized card recommendation',
                boldTitle: true,
                expanded: _expanded,
                onToggle: () => setState(() => _expanded = !_expanded),
                leading: const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                rows: rows,
              ),
            ),
            const VittaDock(),
          ],
        ),
      ),
    );
  }
}
