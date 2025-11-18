import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../chat/chat_screen.dart';
import '../home/home_screen.dart';
import '../language/language_screen.dart';
import '../plans/plans_screen.dart';
import '../settings/settings_screen.dart';

/// Main scaffold screen with bottom navigation.
///
/// Provides navigation between main app sections: Home, Chat, Language, Subscribe, and Settings.
class MainScaffoldScreen extends ConsumerStatefulWidget {
  const MainScaffoldScreen({super.key});

  @override
  ConsumerState<MainScaffoldScreen> createState() => _MainScaffoldScreenState();
}

class _MainScaffoldScreenState extends ConsumerState<MainScaffoldScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      HomeScreen(onNavigateToChat: () => setState(() => _currentIndex = 1)),
      const ChatScreen(),
      const LanguageScreen(),
      const PlansScreen(),
      SettingsScreen(
        onNavigateToLanguage: () {
          setState(() => _currentIndex = 2); // Navigate to Language tab
        },
      ),
    ]);
  }

  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat_bubble_outline),
      activeIcon: Icon(Icons.chat_bubble),
      label: 'Chat',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.language_outlined),
      activeIcon: Icon(Icons.language),
      label: 'Language',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.star_outline),
      activeIcon: Icon(Icons.star),
      label: 'Subscribe',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_outlined),
      activeIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onNavTap,
        destinations: _navItems
            .map(
              (item) => NavigationDestination(
                icon: item.icon,
                selectedIcon: item.activeIcon,
                label: item.label!,
              ),
            )
            .toList(),
      ),
    );
  }
}
