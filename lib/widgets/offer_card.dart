import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'common.dart';

/// Gradient decoration shared by the offer cards (A01 list and A05 hero card).
BoxDecoration offerDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    boxShadow: VShadows.card,
    gradient: const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFFE4EDF8), Color(0xFFFBFCFE), Color(0xFFFCE9DC)],
      stops: [0.0, 0.45, 1.0],
    ),
  );
}

/// The small horizontal "Recommended for you" card (317 x 63).
class OfferCard extends StatelessWidget {
  const OfferCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.subtitleWeight = FontWeight.w400,
    this.imageSize = 64,
    this.imageLeft = 245,
    this.imageTop = 9,
  });

  final String title;
  final String subtitle;
  final String imagePath;
  final FontWeight subtitleWeight;
  final double imageSize;
  final double imageLeft;
  final double imageTop;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 317,
      height: 63,
      decoration: offerDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              left: 12,
              top: 12,
              width: 227,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: vText(14, FontWeight.w700, VColors.primaryHover,
                        height: 1.5),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: vText(12, subtitleWeight, VColors.textPrimary,
                        height: 1.5),
                  ),
                ],
              ),
            ),
            Positioned(
              left: imageLeft,
              top: imageTop,
              child: AssetOrPlaceholder(
                imagePath,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                radius: imageSize / 2,
                icon: Icons.local_offer_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
