import 'package:departures/l10n/app_localizations.dart';
import 'package:departures/pages/favorites_page.dart';
import 'package:departures/pages/home_page.dart';
import 'package:departures/pages/search_page.dart';
import 'package:departures/pages/settings_page.dart';
import 'package:flutter/material.dart';

class TestAppMainPage extends StatefulWidget {
  const TestAppMainPage({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  State<TestAppMainPage> createState() => _TestAppMainPageState();
}

class _TestAppMainPageState extends State<TestAppMainPage> {
  late int _activePage;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _activePage = widget.initialIndex;
    _pages = const [HomePage(), FavoritesPage(), SearchPage(), SettingsPage()];
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(index: _activePage, children: _pages),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: _activePage,
        onDestinationSelected: (int index) {
          setState(() {
            _activePage = index;
          });
        },
        destinations: <Widget>[
          NavigationDestination(
            icon: const Icon(Icons.location_on_outlined),
            selectedIcon: const Icon(Icons.location_on),
            label: appLocalizations.navigationLabelHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.save_outlined),
            selectedIcon: const Icon(Icons.save),
            label: appLocalizations.navigationLabelFavorites,
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_outlined),
            selectedIcon: const Icon(Icons.search),
            label: appLocalizations.navigationLabelSearch,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: appLocalizations.navigationLabelSettings,
          ),
        ],
      ),
    );
  }
}
