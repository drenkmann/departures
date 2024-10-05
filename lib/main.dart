import 'package:departures/home_page.dart';
import 'package:departures/search_page.dart';
import 'package:departures/settings_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DeparturesApp());
}

class DeparturesApp extends StatelessWidget {
  const DeparturesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Departures',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xfff0ca00)),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xfff0ca00), brightness: Brightness.dark),
      ),
      themeMode: ThemeMode.system,
      home: const AppMainPage(),
    );
  }
}

class AppMainPage extends StatefulWidget {
  const AppMainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AppMainPageState createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage> {
  int _currentIndex = 0;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages = [
        const HomePage(),
        const SearchPage(),
        const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      key: scaffoldKey,
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: "Search",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: "Settings"
          ),
        ],
      ),
      // appBar: AppBar(title: Text(_titles[_currentIndex])),
    );
  }
}
