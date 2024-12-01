import 'package:departures/pages/favorites_page.dart';
import 'package:departures/pages/home_page.dart';
import 'package:departures/pages/search_page.dart';
import 'package:departures/pages/settings_page.dart';
import 'package:departures/provider/api_settings_provider.dart';
import 'package:departures/provider/favorites_provider.dart';
import 'package:departures/provider/theme_settings_provider.dart';
import 'package:departures/provider/time_display_settings_provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ApiSettingsProvider()),
        ChangeNotifierProvider(create: (_) => TimeDisplaySettingsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
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
        final SystemUiOverlayStyle overlayStyle = switch (themeProvider.appThemeMode.themeMode) {
          ThemeMode.system =>
            MediaQuery.of(context).platformBrightness == Brightness.light ?
              SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,

          ThemeMode.dark =>
            SystemUiOverlayStyle.light,

          ThemeMode.light =>
            SystemUiOverlayStyle.dark,
        };

        SystemChrome.setSystemUIOverlayStyle(overlayStyle);

        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamicColor, ColorScheme? darkDynamicColor) {
            ColorScheme lightColorScheme;
            ColorScheme darkColorScheme;

            if (themeProvider.materialYou && lightDynamicColor != null && darkDynamicColor != null) {
              lightColorScheme = lightDynamicColor.harmonized();
              darkColorScheme = darkDynamicColor.harmonized();
            } else {
              lightColorScheme = ColorScheme.fromSeed(seedColor: const Color(0xfff0ca00));
              darkColorScheme = ColorScheme.fromSeed(seedColor: const Color(0xfff0ca00), brightness: Brightness.dark);
            }

            return MaterialApp(
              onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightColorScheme,
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: darkColorScheme,
              ),
              themeMode: themeProvider.appThemeMode.themeMode,
              home: const AppMainPage(),
            );
          }
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
  int _activePage = 0;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages = [
        const HomePage(),
        const FavoritesPage(),
        const SearchPage(),
        const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _activePage,
        children: _pages,
      ),
      key: scaffoldKey,
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
            icon: const Icon(Icons.favorite_border_outlined),
            selectedIcon: const Icon(Icons.favorite),
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
      // appBar: AppBar(title: Text(_titles[_currentIndex])),
    );
  }
}
