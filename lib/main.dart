import 'package:flutter/material.dart';

import 'screens/community_screen.dart';
import 'screens/habit_screen.dart';
import 'screens/pantry_screen.dart';
import 'screens/recipe_screen.dart';
import 'screens/waste_audit_screen.dart';
import 'theme/panda_theme.dart';
import 'widgets/panda_chrome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PandaCrumbs',
      debugShowCheckedModeBanner: false,
      theme: buildPandaTheme(),
      home: const CheckpointHome(),
    );
  }
}

class CheckpointHome extends StatefulWidget {
  const CheckpointHome({super.key});

  @override
  State<CheckpointHome> createState() => _CheckpointHomeState();
}

class _CheckpointHomeState extends State<CheckpointHome> {
  int _selectedIndex = 0;

  void _selectTab(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 2
          ? null
          : PandaAppBar(
              onProfileTap: () => showPandaMessage(
                context,
                'Fitur akun PandaCrumbs akan segera hadir.',
              ),
            ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const PantryScreen(),
          const RecipeScreen(),
          WasteAuditScreen(onNavigate: _selectTab),
          const CommunityScreen(),
          const HabitScreen(),
        ],
      ),
      bottomNavigationBar: PandaBottomNavigation(
        selectedIndex: _selectedIndex,
        onSelect: _selectTab,
      ),
    );
  }
}
