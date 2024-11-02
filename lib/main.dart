import 'package:departures/home_page.dart';
import 'package:departures/provider/api_host_settings.dart';
import 'package:departures/provider/theme_settings.dart';
import 'package:departures/search_page.dart';
import 'package:departures/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ApiHostProvider()),
      ],
      child: const DeparturesApp()
    )
  );
}

class DeparturesApp extends StatelessWidget {
  const DeparturesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        SystemChrome.setSystemUIOverlayStyle(
          MediaQuery.of(context).platformBrightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark
        );

        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xfff0ca00)),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xfff0ca00), brightness: Brightness.dark),
          ),
          themeMode: themeProvider.themeMode,
          home: const AppMainPage(),
        );
      }
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
    final appLocalizations = AppLocalizations.of(context)!;

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
        destinations: <Widget>[
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: appLocalizations.navigationLabelHome,
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
      // appBar: AppBar(title: Text(_titles[_currentIndex])),
    );
  }
}
