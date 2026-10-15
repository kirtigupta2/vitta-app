import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/tokens.dart';

class VittaTab {
  const VittaTab(this.label, this.asset, {this.selectedAsset});

  final String label;

  /// Icon used when the tab is not selected.
  final String asset;

  /// Separate icon for the selected state. If null, [asset] is tinted blue.
  final String? selectedAsset;
}

class VittaBottomNav extends StatelessWidget {
  const VittaBottomNav({
    super.key,
    required this.selected,
    required this.onTap,
  });

  static const tabs = <VittaTab>[
    VittaTab('Home', 'assets/icons/tab_home_outline.svg',
        selectedAsset: 'assets/icons/tab_home.svg'),
    VittaTab('Pay', 'assets/icons/tab_pay.svg'),
    VittaTab('Investment', 'assets/icons/tab_investment.svg'),
    VittaTab('Benefits', 'assets/icons/tab_benefits.svg'),
    VittaTab('Vitta', 'assets/icons/tab_vitta.svg',
        selectedAsset: 'assets/icons/tab_vitta_selected.svg'),
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
            SvgPicture.asset(
              selected ? (item.selectedAsset ?? item.asset) : item.asset,
              width: 24,
              height: 24,
              colorFilter: selected && item.selectedAsset == null
                  ? const ColorFilter.mode(VColors.primary, BlendMode.srcIn)
                  : null,
            ),
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

