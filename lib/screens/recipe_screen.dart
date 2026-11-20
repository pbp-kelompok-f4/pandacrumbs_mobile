import 'package:flutter/material.dart';

import '../theme/panda_theme.dart';
import '../widgets/panda_chrome.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PandaPageBackdrop(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PandaPageHeading(title: 'Leftover Recipe', bottomSpacing: 19),
            _RecipeCard(
              category: 'SAYURAN',
              title: 'Nasi goreng telur',
              ingredients: 'jamur · bawang putih · minyak · bawang merah',
              author: 'Oleh DapurPanda',
              art: const _EggPlateArtwork(),
              onOpen: () => _showRecipeDetails(context, 'Nasi goreng telur'),
            ),
            _RecipeCard(
              category: 'CAMILAN',
              title: 'Puding roti tawar',
              ingredients: 'roti tawar · susu · telur · gula',
              author: 'Oleh DapurPanda',
              art: const _BowlArtwork(),
              onOpen: () => _showRecipeDetails(context, 'Puding roti tawar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRecipeDetails(BuildContext context, String title) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: PandaColors.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D5CA),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/images/nasi_goreng.png',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 17),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Gloock',
                  fontSize: 25,
                  color: PandaColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Gunakan bahan yang tersedia di pantry untuk membuat hidangan sederhana dan mengurangi sisa makanan.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: PandaColors.muted,
                ),
              ),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 18,
                    color: PandaColors.olive,
                  ),
                  SizedBox(width: 7),
                  Text(
                    '15 menit',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({
    required this.category,
    required this.title,
    required this.ingredients,
    required this.author,
    required this.art,
    required this.onOpen,
  });

  final String category;
  final String title;
  final String ingredients;
  final String author;
  final Widget art;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: PandaColors.ink.withValues(alpha: .18),
            blurRadius: 9,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 178,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: PandaColors.sagePale),
                art,
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFEFB),
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      '15 menit',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(19, 16, 16, 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD9DFBE), Color(0xFFDF805B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    color: PandaColors.olive,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .4,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: PandaColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7E6DA),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    ingredients,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF74766C),
                      fontSize: 10.5,
                      height: 1.2,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 10),
                  child: Divider(height: 1, color: Color(0x66FFFFFF)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        author,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: PandaColors.ink,
                        ),
                      ),
                    ),
                    Material(
                      color: PandaColors.terracotta,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        onTap: onOpen,
                        borderRadius: BorderRadius.circular(18),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          child: Text(
                            'Lihat resep',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EggPlateArtwork extends StatelessWidget {
  const _EggPlateArtwork();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 78,
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 76,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFD0D9EA),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            Container(
              width: 60,
              height: 23,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F6EE),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            Container(
              width: 31,
              height: 25,
              decoration: BoxDecoration(
                color: const Color(0xFFE8A63B),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            Container(
              width: 15,
              height: 15,
              decoration: const BoxDecoration(
                color: Color(0xFFFFFDF4),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: Color(0xFFE8A63B),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BowlArtwork extends StatelessWidget {
  const _BowlArtwork();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 62,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFF394256),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(35),
          ),
          border: Border.all(color: const Color(0xFF89917A), width: 3),
        ),
        child: const Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 13,
              top: -10,
              child: _TinyIngredient(color: Color(0xFFE19A50)),
            ),
            Positioned(
              left: 27,
              top: -13,
              child: _TinyIngredient(color: Color(0xFF81965F)),
            ),
            Positioned(
              left: 38,
              top: -7,
              child: _TinyIngredient(color: Color(0xFFE6C978)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TinyIngredient extends StatelessWidget {
  const _TinyIngredient({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: const Color(0xFFFAF6EE), width: 1),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
