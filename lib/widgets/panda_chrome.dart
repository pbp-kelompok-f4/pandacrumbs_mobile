import 'package:flutter/material.dart';

import '../theme/panda_theme.dart';

class PandaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PandaAppBar({super.key, required this.onProfileTap});

  final VoidCallback onProfileTap;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 64,
      automaticallyImplyLeading: false,
      titleSpacing: 18,
      title: Row(
        children: [
          Image.asset(
            'assets/images/panda_logo.png',
            width: 34,
            height: 40,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 9),
          const Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'PandaCrumbs',
                style: TextStyle(
                  fontFamily: 'Gloock',
                  fontSize: 23,
                  color: PandaColors.ink,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 17),
          child: InkWell(
            onTap: onProfileTap,
            customBorder: const CircleBorder(),
            child: const CircleAvatar(
              radius: 21,
              backgroundColor: Color(0xFFDDE0D5),
              child: Icon(
                Icons.person_outline_rounded,
                size: 22,
                color: PandaColors.oliveDark,
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: PandaColors.line),
      ),
    );
  }
}

class PandaBottomNavigation extends StatelessWidget {
  const PandaBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const _items = <_NavigationItemData>[
    _NavigationItemData('Pantry', Icons.inventory_2_outlined),
    _NavigationItemData('Recipe', Icons.menu_book_outlined),
    _NavigationItemData('Waste Audit', Icons.receipt_long_outlined),
    _NavigationItemData('Community', Icons.people_outline_rounded),
    _NavigationItemData('Habit', Icons.emoji_events_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: PandaColors.paper,
        border: Border(top: BorderSide(color: PandaColors.line, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              for (var index = 0; index < _items.length; index++)
                Expanded(
                  child: _NavigationItem(
                    item: _items[index],
                    selected: index == selectedIndex,
                    onTap: () => onSelect(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationItemData {
  const _NavigationItemData(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavigationItemData item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 36,
              height: 30,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFDDE0D5) : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: Icon(item.icon, size: 21, color: PandaColors.oliveDark),
            ),
            const SizedBox(height: 3),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.label,
                maxLines: 1,
                style: TextStyle(
                  color: PandaColors.ink,
                  fontSize: 9.5,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PandaPageBackdrop extends StatelessWidget {
  const PandaPageBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: ColoredBox(color: PandaColors.paper)),
        const Positioned(top: 34, left: 42, child: _PandaWatermark(size: 82)),
        const Positioned(top: 300, right: 25, child: _PandaWatermark(size: 74)),
        const Positioned(
          bottom: 66,
          left: 58,
          child: _PandaWatermark(size: 69),
        ),
        child,
      ],
    );
  }
}

class _PandaWatermark extends StatelessWidget {
  const _PandaWatermark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: .055,
        child: Image.asset(
          'assets/images/panda_logo.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class PandaPageHeading extends StatelessWidget {
  const PandaPageHeading({
    super.key,
    required this.title,
    this.subtitle,
    this.bottomSpacing = 18,
  });

  final String title;
  final String? subtitle;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(17, 17, 17, bottomSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Gloock',
              fontSize: 28,
              height: 1.12,
              letterSpacing: -.45,
              color: PandaColors.ink,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 17),
            Text(
              subtitle!,
              style: const TextStyle(
                color: Color(0xFF7D796F),
                fontSize: 14,
                height: 1.55,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

void showPandaMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: PandaColors.oliveDark,
      ),
    );
}
