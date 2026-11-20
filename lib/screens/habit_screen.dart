import 'package:flutter/material.dart';

import '../theme/panda_theme.dart';
import '../widgets/panda_chrome.dart';

class HabitScreen extends StatelessWidget {
  const HabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PandaPageBackdrop(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PandaPageHeading(title: 'Habit Challenge', bottomSpacing: 19),
            _HabitCard(
              title: 'Pakai stok tersisa',
              subtitle: 'Temukan menu dari pantry',
              ingredients: const ['Bayam', 'Telur', 'Bawang', 'Susu'],
              action: 'Lihat bahan & resep',
              onTap: () => showPandaMessage(
                context,
                'Resep akan disesuaikan dengan bahan di pantry.',
              ),
            ),
            _HabitCard(
              title: 'Olah makanan sisa',
              subtitle: 'Beri makanan sisa ide baru',
              ingredients: const ['Nasi matang (2 porsi)'],
              action: 'Lihat resep olahan yang cocok',
              onTap: () => showPandaMessage(
                context,
                'Mencari ide resep dari makanan sisamu.',
              ),
            ),
            _HabitCard(
              title: 'Berbagi makanan',
              subtitle: 'Bagi makanan berlebih',
              ingredients: const ['Sup sayur (2 porsi)', 'Nasi bakar'],
              action: 'Bagikan makanan',
              onTap: () => showPandaMessage(
                context,
                'Fitur berbagi makanan akan segera hadir.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({
    required this.title,
    required this.subtitle,
    required this.ingredients,
    required this.action,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final List<String> ingredients;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(17, 0, 17, 28),
      decoration: BoxDecoration(
        color: PandaColors.warmCard,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: PandaColors.ink.withValues(alpha: .16),
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
            padding: const EdgeInsets.fromLTRB(20, 16, 18, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [PandaColors.terracotta, Color(0xFFDDE4C8)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF5A514D),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: ingredients.map((ingredient) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: const Color(0xFFEDE8E2)),
                      ),
                      child: Text(
                        ingredient,
                        style: const TextStyle(
                          color: Color(0xFF514943),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                const Text(
                  '+10 poin setelah memasak',
                  style: TextStyle(
                    color: PandaColors.olive,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onTap,
                    style: FilledButton.styleFrom(
                      backgroundColor: PandaColors.terracotta,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(32),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      action,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
