import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../state/vitta_session.dart';
import '../theme/tokens.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/common.dart';
import '../widgets/offer_card.dart';
import 'card_intro_screen.dart';
import 'vitta_build_screen.dart';
import 'vitta_overlay.dart';

/// A01: Home. Long-press any card to ask Vitta (A02 -> A03 -> A04 -> A05).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Figma shows the balance hidden by default.
  bool _hidden = true;

  String get _balance => _hidden ? '\$ ••••••' : '\$ 12,450.00';

  void _showBalanceDetails() {
    final masked = _hidden;
    Widget line(String name, String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text(name, style: vText(14, FontWeight.w400, VColors.textSecondary)),
              const Spacer(),
              Text(
                masked ? '••••••' : value,
                style: vText(14, FontWeight.w700, VColors.textPrimary),
              ),
            ],
          ),
        );

    // Demo numbers: the Figma file only shows the hidden state.
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Balance details',
                style: vText(18, FontWeight.w700, VColors.textPrimary)),
            const SizedBox(height: 12),
            line('Checking', '\$ 8,240.50'),
            line('Savings', '\$ 4,210.00'),
            const Divider(height: 24, color: VColors.border),
            line('Total', '\$ 12,450.50'),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) =>
      Text(text,
          style: vText(16, FontWeight.w700, VColors.textPrimary, height: 18 / 16));

  Widget _padded(Widget child) =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 15), child: child);

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              // The avatar PNG is a transparent cut-out, so it needs the
              // light-blue circle behind it.
              ClipOval(
                child: ColoredBox(
                  color: VColors.blue100,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: const AssetOrPlaceholder(
                      'assets/images/avatar.png',
                      width: 40,
                      height: 40,
                      alignment: Alignment.topCenter,
                      radius: 20,
                      icon: Icons.person,
                      color: VColors.blue100,
                      iconColor: VColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Hello Alex,',
                style: vText(24, FontWeight.w700, Colors.white,
                    height: 1.25, letterSpacing: -0.6),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Notifications',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 44, height: 44),
                onPressed: () => showProto(context, 'Notifications'),
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x40073373),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x40051F4D),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset('assets/icons/bell.svg',
                        width: 16, height: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 36,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Balance',
                      style: vText(14, FontWeight.w400, Colors.white,
                          height: 1.25)),
                  Text(_balance,
                      style: vText(16, FontWeight.w700, Colors.white,
                          height: 1.1)),
                ],
              ),
              const Spacer(),
              IconButton(
                tooltip: _hidden ? 'Show balance' : 'Hide balance',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 28, height: 44),
                onPressed: () => setState(() => _hidden = !_hidden),
                icon: Icon(
                  _hidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              Transform.translate(
                offset: const Offset(5, 0),
                child: IconButton(
                  tooltip: 'Expand balance details',
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints.tightFor(width: 28, height: 44),
                  onPressed: _showBalanceDetails,
                  icon: const Icon(Icons.keyboard_arrow_down,
                      size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 34),
        SizedBox(
          height: 54,
          child: Row(
            children: const [
              Expanded(child: _QuickAction('Transfer', asset: 'assets/icons/qa_transfer.svg')),
              _QuickDivider(),
              Expanded(child: _QuickAction('Statement', icon: Symbols.receipt_long)),
              _QuickDivider(),
              Expanded(child: _QuickAction('Rewards', asset: 'assets/icons/qa_rewards.svg')),
              _QuickDivider(),
              Expanded(
                  child: _QuickAction('Wallet', asset: 'assets/icons/qa_wallet.svg')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _offerList() {
    return SizedBox(
      height: 63,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: const [
          AskVittaCard(
            child: OfferCard(
              title: 'Save on Dining with Credit Card',
              subtitle: '10% Uber Eats Cashback',
              imagePath: 'assets/images/offer_dining.png',
              imageSize: 64,
              imageLeft: 245,
              imageTop: 9,
            ),
          ),
          SizedBox(width: 16),
          AskVittaCard(
            child: OfferCard(
              title: 'Create Concert Budget',
              subtitle: 'Attended 6 concerts last month alone',
              subtitleWeight: FontWeight.w500,
              imagePath: 'assets/images/offer_concert.png',
              imageSize: 78,
              imageLeft: 239,
              imageTop: 3,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration get _whiteCard => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: VShadows.card,
      );

  Widget _portfolioCard() {
    return AskVittaCard(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: _whiteCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Potential investments areas for you',
              style: vText(14, FontWeight.w500, VColors.textPrimary, height: 18 / 14),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: _Stock(
                    symbol: 'LCID',
                    change: '+28.79%',
                    asset: 'assets/images/logo_lcid.png',
                    bg: Color(0xFF111111),
                    fg: Colors.white70,
                    icon: Icons.electric_car,
                  ),
                ),
                Expanded(
                  child: _Stock(
                    symbol: 'CHRN',
                    change: '+28.71%',
                    asset: 'assets/images/logo_chrn.png',
                    bg: Color(0xFFEEF2F7),
                    fg: Colors.black54,
                    icon: Icons.circle_outlined,
                  ),
                ),
                Expanded(
                  child: _Stock(
                    symbol: 'SAH',
                    change: '+7.96%',
                    asset: 'assets/images/logo_sah.png',
                    bg: Color(0xFFE23B2E),
                    fg: Colors.white,
                    icon: Icons.bolt,
                    logoSize: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentsCard() {
    return AskVittaCard(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: _whiteCard,
        child: Column(
          children: [
            _PaymentRow(
              name: 'Comcast',
              due: 'Due on 10 July, 2026',
              amount: '\$120',
              onTap: () => showProto(context, 'Payment details'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                height: 0.5,
                thickness: 0.5,
                color: Color(0x266D8FFF),
              ),
            ),
            _PaymentRow(
              name: 'Netflix Subscription',
              due: 'Due on 23 July, 2026',
              amount: '\$40',
              onTap: () => showProto(context, 'Payment details'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).padding;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: VColors.sheet,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: pad.top + 241,
              child: const _HeaderBackground(),
            ),
            // Translucent panel behind the quick actions.
            Positioned(
              top: pad.top + 119,
              left: 16,
              right: 16,
              height: 82,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0x40073373),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x40051F4D),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: pad.top + 3,
              left: 16,
              right: 16,
              child: _header(),
            ),
            // White content sheet.
            Positioned(
              top: pad.top + 195,
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: ColoredBox(
                  color: VColors.sheet,
                  child: ListView(
                    padding: EdgeInsets.only(top: 16, bottom: 110 + pad.bottom),
                    children: [
                      _padded(
                        SizedBox(
                          height: 23,
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/icons/vitta.svg',
                                  width: 14, height: 14),
                              const SizedBox(width: 6),
                              Text(
                                'Long press any card to ask Vitta about it',
                                style: vText(11, FontWeight.w700, VColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _padded(_title('Recommended for you')),
                      const SizedBox(height: 12),
                      _offerList(),
                      const SizedBox(height: 16),
                      _padded(_title('Grow Your Portfolio')),
                      const SizedBox(height: 12),
                      _padded(_portfolioCard()),
                      const SizedBox(height: 16),
                      _padded(
                        SizedBox(
                          height: 22.5,
                          child: Row(
                            children: [
                              Text(
                                'Upcoming Payments',
                                style: vText(16, FontWeight.w700,
                                    VColors.textPrimary,
                                    height: 22.5 / 16),
                              ),
                              const Spacer(),
                              InkResponse(
                                radius: 22,
                                onTap: () =>
                                    showProto(context, 'Upcoming payments'),
                                child: const Icon(Icons.chevron_right,
                                    size: 20, color: VColors.textPrimary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _padded(_paymentsCard()),
                    ],
                  ),
                ),
              ),
            ),
            // Soft fade so the page content does not run into the nav bar.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 110 + pad.bottom,
              child: const IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x00F4F8FC),
                        Color(0xE6F4F8FC),
                        Color(0xF7F4F8FC),
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            // Floating bottom navigation.
            Positioned(
              left: 17.5,
              right: 17.5,
              bottom: 16 + pad.bottom,
              child: VittaBottomNav(
                selected: 0,
                onTap: (i) {
                  if (i != 0) showProto(context, VittaBottomNav.tabs[i].label);
                },
              ),
            ),
            // Minimized Vitta: small floating card, bottom right (Figma 24:8829).
            Positioned(
              right: 16,
              bottom: pad.bottom + 100,
              child: ValueListenableBuilder<MiniStatus?>(
                valueListenable: VittaSession.mini,
                builder: (context, status, _) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOutCubic,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      alignment: Alignment.bottomRight,
                      scale: Tween<double>(begin: 0.85, end: 1).animate(animation),
                      child: child,
                    ),
                  ),
                  child: status == null
                      ? const SizedBox.shrink(key: ValueKey('none'))
                      : _MiniVitta(
                          key: ValueKey(status),
                          status: status,
                          onOpen: () {
                            VittaSession.clear();
                            Navigator.of(context).push(fadeRoute(
                              status == MiniStatus.ready
                                  ? const CardIntroScreen()
                                  : const VittaBuildScreen(),
                            ));
                          },
                          onDismiss: VittaSession.clear,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: Color(0xFF2F6FB0)),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(1.0, -1.0),
              radius: 0.9,
              colors: [Color(0x80FFC9A6), Color(0x00FFC9A6)],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.85, 0.3),
              radius: 0.7,
              colors: [Color(0xBF6497CE), Color(0x006497CE)],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-1.0, -1.0),
              radius: 0.9,
              colors: [Color(0xB31F5AA0), Color(0x001F5AA0)],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction(this.label, {this.asset, this.icon});

  final String label;
  final String? asset; // Figma SVG (40 x 40 box)
  final IconData? icon; // fallback when no SVG is available

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => showProto(context, label),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 40 px icon box that overlaps the label by 4 px, as in Figma.
          SizedBox(
            height: 36,
            child: OverflowBox(
              alignment: Alignment.topCenter,
              minHeight: 0,
              maxHeight: 40,
              child: asset != null
                  ? SvgPicture.asset(asset!, width: 40, height: 40)
                  : SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(icon, size: 22, weight: 300, color: Colors.white),
                    ),
            ),
          ),
          Text(label, style: vText(12, FontWeight.w400, Colors.white, height: 1.5)),
        ],
      ),
    );
  }
}

class _QuickDivider extends StatelessWidget {
  const _QuickDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00FFFFFF), Color(0x4DFFFFFF), Color(0x00FFFFFF)],
        ),
      ),
    );
  }
}

class _Stock extends StatelessWidget {
  const _Stock({
    required this.symbol,
    required this.change,
    required this.asset,
    required this.bg,
    required this.fg,
    required this.icon,
    this.logoSize = 36,
  });

  final double logoSize;
  final String symbol;
  final String change;
  final String asset;
  final Color bg;
  final Color fg;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AssetOrPlaceholder(
          asset,
          width: logoSize,
          height: logoSize,
          radius: 6.4,
          icon: icon,
          color: bg,
          iconColor: fg,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(symbol,
                  maxLines: 1,
                  style: vText(14, FontWeight.w500, VColors.textSecondary,
                      height: 1.3)),
              Text(change,
                  maxLines: 1,
                  style: vText(12, FontWeight.w500, VColors.success,
                      height: 1.5)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.name,
    required this.due,
    required this.amount,
    required this.onTap,
  });

  final String name;
  final String due;
  final String amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: vText(14, FontWeight.w500, VColors.textPrimary,
                        height: 1.5)),
                const SizedBox(height: 2),
                Text(due,
                    style: vText(12, FontWeight.w400, VColors.textSecondary,
                        height: 1.5)),
              ],
            ),
          ),
          Text(amount, style: vText(14, FontWeight.w700, VColors.textPrimary)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 12, color: VColors.textPrimary),
        ],
      ),
    );
  }
}

/// The minimized Vitta agent: a 155 x 135 card at the bottom right of Home.
class _MiniVitta extends StatelessWidget {
  const _MiniVitta({
    super.key,
    required this.status,
    required this.onOpen,
    required this.onDismiss,
  });

  final MiniStatus status;
  final VoidCallback onOpen;
  final VoidCallback onDismiss;

  Widget _smallButton(IconData icon, String tip, VoidCallback onTap) {
    return Semantics(
      button: true,
      label: tip,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          width: 24,
          height: 24,
          child: Icon(icon, size: 12, weight: 500, color: VColors.textPrimary),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ready = status == MiniStatus.ready;
    return Container(
      width: 155,
      height: 135,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: VShadows.floating,
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFE9F0F9), Color(0xFFFBFCFE), Color(0xFFFCE9DC)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onOpen,
          child: Stack(
            children: [
              Positioned(
                left: 12,
                right: 12,
                top: 12,
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/vitta.svg',
                        width: 16, height: 16),
                    const SizedBox(width: 5),
                    Text(
                      'Vitta',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 14,
                        height: 16.5 / 14,
                        color: VColors.primary,
                      ),
                    ),
                    const Spacer(),
                    _smallButton(Symbols.open_in_full, 'Open Vitta', onOpen),
                    const SizedBox(width: 4),
                    _smallButton(Symbols.close, 'Close Vitta', onDismiss),
                  ],
                ),
              ),
              Positioned(
                left: 12,
                top: 37,
                width: 129.667,
                height: 85.167,
                child: Container(
                  padding: const EdgeInsets.all(8.667),
                  decoration: BoxDecoration(
                    color: const Color(0x80FFFFFF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: const Color(0x14FFFFFF), width: 0.667),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 35,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Save on Dining with Credit Card',
                            style: vText(
                                14, FontWeight.w500, VColors.textPrimary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ready
                            ? Text(
                                'Tap to view details',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: vText(
                                    12, FontWeight.w400, VColors.textSecondary,
                                    height: 1.0),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      color: VColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Building...',
                                    style: vText(12, FontWeight.w400,
                                        VColors.textSecondary,
                                        height: 1.0),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
