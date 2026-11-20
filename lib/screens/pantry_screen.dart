import 'package:flutter/material.dart';

import '../theme/panda_theme.dart';
import '../widgets/panda_chrome.dart';

class PantryScreen extends StatefulWidget {
  const PantryScreen({super.key});

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  int _mangoQuantity = 4;
  int _milkQuantity = 2;

  @override
  Widget build(BuildContext context) {
    return PandaPageBackdrop(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PandaPageHeading(title: 'Smart Pantry', bottomSpacing: 19),
            _PantryItemCard(
              name: 'Mangga',
              quantity: _mangoQuantity,
              expiry: '12 Oktober 2026',
              added: '5 September 2026',
              type: 'Buah Segar',
              artwork: Image.asset(
                'assets/images/pantry_mascot.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              onUpdate: () => showPandaMessage(
                context,
                'Informasi Mangga siap diperbarui.',
              ),
              onReduce: () {
                setState(() {
                  if (_mangoQuantity > 0) _mangoQuantity--;
                });
              },
            ),
            _PantryItemCard(
              name: 'Susu Sapi',
              quantity: _milkQuantity,
              expiry: '29 November 2026',
              added: '8 November 2026',
              type: 'Produk Susu',
              artwork: const _MilkArtwork(),
              onUpdate: () => showPandaMessage(
                context,
                'Informasi Susu Sapi siap diperbarui.',
              ),
              onReduce: () {
                setState(() {
                  if (_milkQuantity > 0) _milkQuantity--;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PantryItemCard extends StatelessWidget {
  const _PantryItemCard({
    required this.name,
    required this.quantity,
    required this.expiry,
    required this.added,
    required this.type,
    required this.artwork,
    required this.onUpdate,
    required this.onReduce,
  });

  final String name;
  final int quantity;
  final String expiry;
  final String added;
  final String type;
  final Widget artwork;
  final VoidCallback onUpdate;
  final VoidCallback onReduce;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 27),
      decoration: BoxDecoration(
        color: PandaColors.warmCard,
        borderRadius: BorderRadius.circular(27),
        boxShadow: [
          BoxShadow(
            color: PandaColors.ink.withValues(alpha: .17),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 21),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [PandaColors.terracotta, Color(0xFFDDE4C8)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: onUpdate,
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      child: Text(
                        'Update',
                        style: TextStyle(
                          color: PandaColors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 1.04,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        artwork,
                        if (name == 'Mangga')
                          const Positioned(
                            top: 11,
                            left: 9,
                            child: _ExpiryBadge(),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                _PantryDetail(label: 'Kedaluwarsa', value: expiry),
                _PantryDetail(label: 'Tanggal Masuk', value: added),
                _PantryDetail(label: 'Jenis', value: type),
                _PantryDetail(label: 'Kuantitas', value: '$quantity'),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Material(
                    color: PandaColors.terracotta,
                    borderRadius: BorderRadius.circular(21),
                    child: InkWell(
                      onTap: onReduce,
                      borderRadius: BorderRadius.circular(21),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          'Kurangi Kuantitas (-1)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
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

class _PantryDetail extends StatelessWidget {
  const _PantryDetail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: Text(
        '$label : $value',
        style: const TextStyle(
          fontSize: 13.6,
          height: 1.14,
          fontWeight: FontWeight.w600,
          color: PandaColors.ink,
        ),
      ),
    );
  }
}

class _ExpiryBadge extends StatelessWidget {
  const _ExpiryBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
      decoration: BoxDecoration(
        color: PandaColors.terracotta,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Text(
        'Hampir Kadaluarsa',
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MilkArtwork extends StatelessWidget {
  const _MilkArtwork();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE9EFE0),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 122,
            height: 122,
            decoration: const BoxDecoration(
              color: Color(0xFFDDE6CE),
              shape: BoxShape.circle,
            ),
          ),
          const Icon(
            Icons.local_drink_rounded,
            size: 85,
            color: Color(0xFF75815C),
          ),
        ],
      ),
    );
  }
}
