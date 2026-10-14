import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/vitta_session.dart';
import '../theme/tokens.dart';
import '../widgets/agent_log.dart';
import '../widgets/common.dart';
import '../widgets/offer_card.dart';

String _money(int v) {
  final s = v.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return '\$$b';
}

/// A05: savings count-up, offer card, and the Key benefits / How it works tabs.
class CardIntroScreen extends StatefulWidget {
  const CardIntroScreen({super.key});

  @override
  State<CardIntroScreen> createState() => _CardIntroScreenState();
}

class _CardIntroScreenState extends State<CardIntroScreen> {
  static const _finished = [
    'Analyzed spending behavior',
    'Explored credit card savings opportunities',
    'Evaluated eligibility signals',
    'Built personalized application journey',
    'Prepared recommendations and next steps',
  ];

  int _tab = 0;
  bool _logOpen = false;
  bool _countUp = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 450), () {
      if (mounted) setState(() => _countUp = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _hero(bool reduceMotion) {
    final end = (_countUp || reduceMotion) ? 1200 : 0;
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          'Your potential yearly savings',
          style: vText(14, FontWeight.w500, VColors.textSecondary),
        ),
        TweenAnimationBuilder<int>(
          tween: IntTween(begin: 0, end: end),
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 1800),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => Semantics(
            label: '\$1,200 plus',
            excludeSemantics: true,
            child: Text(
              value >= 1200 ? '\$1,200+' : _money(value),
              textAlign: TextAlign.center,
              style: vText(
                56,
                FontWeight.w700,
                VColors.success,
                height: 64 / 56,
                letterSpacing: -1.12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _offerCard() {
    return Container(
      height: 104,
      decoration: offerDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              left: 11,
              top: 13,
              right: 104,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Save on Dining with Credit Card',
                    style: vText(16, FontWeight.w700, VColors.textPrimary,
                        height: 1.3),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'You spend 10% for your spendings on dinning, it is your biggest spending category.',
                    style: vText(14, FontWeight.w400, VColors.textSecondary,
                        height: 18 / 14),
                  ),
                ],
              ),
            ),
            const Positioned(
              right: 1,
              top: 21,
              child: AssetOrPlaceholder(
                'assets/images/offer_dining.png',
                width: 102,
                height: 102,
                radius: 51,
                icon: Icons.local_offer_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _benefits() {
    return Column(
      key: const ValueKey('benefits'),
      children: const [
        _BenefitRow(
          icon: Icons.payments_outlined,
          title: '10% Cashback',
          subtitle: 'On dining purchases',
        ),
        _BenefitRow(
          icon: Icons.card_giftcard,
          title: '15% Discount',
          subtitle: 'At select partners',
        ),
        _BenefitRow(
          icon: Icons.money_off,
          title: 'No Annual Fee',
          subtitle: 'No yearly charge',
          divider: false,
        ),
      ],
    );
  }

  // The Figma file does not design the "How it works" tab, so this copy is a
  // placeholder. Replace it with your own text.
  Widget _howItWorks() {
    return Column(
      key: const ValueKey('how'),
      children: const [
        _BenefitRow(
          icon: Icons.link,
          title: 'Link your spending',
          subtitle: 'Vitta reviews your recent transactions',
        ),
        _BenefitRow(
          icon: Icons.auto_awesome,
          title: 'Get matched',
          subtitle: 'We find the card that fits how you spend',
        ),
        _BenefitRow(
          icon: Icons.verified_outlined,
          title: 'Apply in minutes',
          subtitle: 'Your application journey is prepared for you',
          divider: false,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).padding;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            const Positioned.fill(child: VittaBackground()),
            Positioned.fill(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, pad.top + 62, 16, pad.bottom + 190),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AgentLogCard(
                      title: 'Agent Actions (${_finished.length})',
                      expanded: _logOpen,
                      onToggle: () => setState(() => _logOpen = !_logOpen),
                      rows: [
                        for (final s in _finished) LogRow(text: s, done: true),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _hero(reduceMotion),
                    const SizedBox(height: 24),
                    _offerCard(),
                    const SizedBox(height: 24),
                    _Segmented(
                      index: _tab,
                      onChanged: (i) => setState(() => _tab = i),
                    ),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _tab == 0 ? _benefits() : _howItWorks(),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: pad.top + 70,
              child: const IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xF5EAF1F9), Color(0xEBEAF1F9), Color(0x00EAF1F9)],
                      stops: [0.0, 0.82, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: pad.top + 12,
              left: 16,
              right: 16,
              child: const VittaTopBar(
                serifBrand: true,
                minimizeStatus: MiniStatus.ready,
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: pad.bottom + 72,
              child: _GetStartedButton(
                onTap: () => showProto(context, 'The next step after Get Started'),
              ),
            ),
            const VittaDock(),
          ],
        ),
      ),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 5),
        ],
      ),
      child: Material(
        color: VColors.primary,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: SizedBox(
            height: 48,
            child: Center(
              child: Text(
                'Get Started',
                style: vText(16, FontWeight.w700, Colors.white,
                    letterSpacing: -0.32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Segmented extends StatelessWidget {
  const _Segmented({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  Widget _label(String text, int i) {
    final selected = index == i;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(i),
      child: Center(
        child: Text(
          text,
          style: vText(
            14,
            selected ? FontWeight.w700 : FontWeight.w500,
            selected ? VColors.textPrimary : VColors.textSecondary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final half = constraints.maxWidth / 2;
        return Container(
          height: 40,
          decoration: BoxDecoration(
            color: VColors.surfaceMuted,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                left: index == 0 ? 2 : half,
                top: 2,
                width: half - 2,
                height: 36,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x29084AA3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(child: _label('Key benefits', 0)),
                  Expanded(child: _label('How it works', 1)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.divider = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Stack(
        children: [
          Positioned(
            left: 1,
            top: 15,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE3EBFA),
              ),
              child: Icon(icon, size: 22, color: VColors.primary),
            ),
          ),
          Positioned(
            left: 60,
            top: 14,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: vText(16, FontWeight.w700, VColors.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: vText(13, FontWeight.w400, VColors.textSecondary),
                ),
              ],
            ),
          ),
          if (divider)
            const Positioned(
              left: 60,
              right: 0,
              bottom: 0,
              height: 1,
              child: ColoredBox(color: VColors.border),
            ),
        ],
      ),
    );
  }
}
