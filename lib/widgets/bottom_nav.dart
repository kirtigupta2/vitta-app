import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class VittaTab {
  const VittaTab(this.label, this.icon);

  final String label;
  final IconData icon;
}

class VittaBottomNav extends StatelessWidget {
  const VittaBottomNav({
    super.key,
    required this.selected,
    required this.onTap,
  });

  static const tabs = <VittaTab>[
    VittaTab('Home', Icons.home_rounded),
    VittaTab('Pay', Icons.payments_outlined),
    VittaTab('Investment', Icons.trending_up),
    VittaTab('Benefits', Icons.card_giftcard),
    VittaTab('Vitta', Icons.auto_awesome),
  ];

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

  final VittaTab item;
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

