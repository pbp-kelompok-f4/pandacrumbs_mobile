import 'package:flutter/material.dart';

import '../theme/panda_theme.dart';
import '../widgets/panda_chrome.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PandaPageBackdrop(
      child: Stack(
        children: [
          const Positioned(top: 194, right: 34, child: _SoftDot(size: 10)),
          const Positioned(top: 298, left: 27, child: _SoftDot(size: 8)),
          const Positioned(top: 441, right: 29, child: _SoftDot(size: 12)),
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const PandaPageHeading(
                  title: 'Community Sharing',
                  bottomSpacing: 24,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 17),
                  height: 94,
                  padding: const EdgeInsets.fromLTRB(15, 13, 15, 12),
                  decoration: BoxDecoration(
                    color: PandaColors.paper.withValues(alpha: .88),
                    border: Border.all(
                      color: const Color(0xFFDDE0D0),
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Kerangka halaman modul',
                    style: TextStyle(
                      color: Color(0xFF746E65),
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftDot extends StatelessWidget {
  const _SoftDot({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xFFECE2CF),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
