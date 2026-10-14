import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Collapsible "Agent Actions" card used on A04 and A05.
class AgentLogCard extends StatelessWidget {
  const AgentLogCard({
    super.key,
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.rows,
    this.leading,
    this.boldTitle = false,
  });

  final String title;
  final bool expanded;
  final VoidCallback onToggle;
  final List<Widget> rows;
  final Widget? leading;
  final bool boldTitle;

  @override
  Widget build(BuildContext context) {
    final spaced = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      if (i > 0) spaced.add(const SizedBox(height: 12));
      spaced.add(rows[i]);
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xCCFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 9.5),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: 6),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: vText(
                          14,
                          boldTitle ? FontWeight.w700 : FontWeight.w400,
                          VColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_down,
                          size: 18, color: VColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: expanded
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                      child: Column(
                        children: [
                          const Divider(
                            height: 1,
                            thickness: 0.7,
                            color: VColors.border,
                          ),
                          const SizedBox(height: 16),
                          ...spaced,
                        ],
                      ),
                    )
                  : const SizedBox(width: double.infinity, height: 0),
            ),
          ],
        ),
      ),
    );
  }
}

/// One line of the agent log: spinner while running, green check when done.
class LogRow extends StatelessWidget {
  const LogRow({super.key, required this.text, required this.done});

  final String text;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2, left: 1),
          child: SizedBox(
            width: 16,
            height: 16,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: done
                  ? const Icon(Icons.check_circle,
                      key: ValueKey('done'), size: 16, color: VColors.success)
                  : const CircularProgressIndicator(
                      key: ValueKey('running'),
                      strokeWidth: 2,
                      color: VColors.primary,
                    ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: vText(14, FontWeight.w400, VColors.textPrimary, height: 1.39),
          ),
        ),
      ],
    );
  }
}
