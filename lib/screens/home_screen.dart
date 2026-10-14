import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../widgets/offer_card.dart';
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

  static const _tabs = <_TabItem>[
    _TabItem('Home', Icons.home_rounded),
    _TabItem('Pay', Icons.payments_outlined),
    _TabItem('Investment', Icons.trending_up),
    _TabItem('Benefits', Icons.card_giftcard),
    _TabItem('Vitta', Icons.auto_awesome),
  ];

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
      Text(text, style: vText(16, FontWeight.w700, VColors.textPrimary, height: 1.4));

  Widget _padded(Widget child) =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 15), child: child);

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44,
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
                  child: const Icon(Icons.notifications_none,
                      size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
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
              Expanded(child: _QuickAction(Symbols.swap_horiz, 'Transfer')),
              _QuickDivider(),
              Expanded(child: _QuickAction(Symbols.receipt_long, 'Statement')),
              _QuickDivider(),
              Expanded(child: _QuickAction(Symbols.star, 'Rewards')),
              _QuickDivider(),
              Expanded(
                  child: _QuickAction(Symbols.account_balance_wallet, 'Wallet')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _offerList() {
    return SizedBox(
      height: 79,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
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
              style: vText(14, FontWeight.w400, VColors.textPrimary, height: 1.3),
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
              height: pad.top + 260,
              child: const _HeaderBackground(),
            ),
            // Translucent panel behind the quick actions.
            Positioned(
              top: pad.top + 149,
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
              top: pad.top + 33,
              left: 16,
              right: 16,
              child: _header(),
            ),
            // White content sheet.
            Positioned(
              top: pad.top + 225,
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
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome,
                                size: 14, color: VColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Long press any card to ask Vitta about it',
                              style: vText(11, FontWeight.w700, VColors.primary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _padded(_title('Recommended for you')),
                      const SizedBox(height: 4),
                      _offerList(),
                      const SizedBox(height: 8),
                      _padded(_title('Grow Your Portfolio')),
                      const SizedBox(height: 12),
                      _padded(_portfolioCard()),
                      const SizedBox(height: 24),
                      _padded(
                        Row(
                          children: [
                            _title('Upcoming Payments'),
                            const Spacer(),
                            IconButton(
                              tooltip: 'View upcoming payments',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(
                                  width: 32, height: 32),
                              onPressed: () =>
                                  showProto(context, 'Upcoming payments'),
                              icon: const Icon(Icons.chevron_right,
                                  size: 22, color: VColors.textPrimary),
                            ),
                          ],
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
              child: _BottomNav(
                tabs: _tabs,
                selected: 0,
                onTap: (i) {
                  if (i != 0) showProto(context, _tabs[i].label);
                },
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
  const _QuickAction(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => showProto(context, label),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 36,
            child: Icon(icon, size: 24, weight: 300, color: Colors.white),
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
  });

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
          width: 36,
          height: 36,
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
                Text(due,
                    style: vText(12, FontWeight.w400, VColors.textSecondary,
                        height: 1.5)),
              ],
            ),
          ),
          Text(amount, style: vText(14, FontWeight.w700, VColors.textPrimary)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 16, color: VColors.textPrimary),
        ],
      ),
    );
  }
}

class _TabItem {
  const _TabItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.tabs,
    required this.selected,
    required this.onTap,
  });

  final List<_TabItem> tabs;
  final int selected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xF7FFFFFF),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0x266D8FFF)),
        boxShadow: VShadows.floating,
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++)
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => onTap(i),
                child: _TabButton(item: tabs[i], selected: i == selected),
              ),
            ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({required this.item, required this.selected});

  final _TabItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? VColors.primary : VColors.textSecondary;
    return Stack(
      alignment: Alignment.center,
      children: [
        if (selected)
          Container(
            width: 64,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const RadialGradient(
                colors: [Color(0x33084BA4), Color(0x00084BA4)],
              ),
            ),
          ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, size: 22, color: color),
            Text(
              item.label,
              maxLines: 1,
              style: vText(11, FontWeight.w700, color, height: 1.1),
            ),
          ],
        ),
      ],
    );
  }
}
