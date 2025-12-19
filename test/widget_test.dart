import 'package:departures/main.dart';
import 'package:departures/provider/api_settings_provider.dart';
import 'package:departures/provider/favorites_provider.dart';
import 'package:departures/provider/theme_settings_provider.dart';
import 'package:departures/provider/time_display_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestApp() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ApiSettingsProvider()),
        ChangeNotifierProvider(create: (_) => TimeDisplaySettingsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const DeparturesApp(),
    );
  }

  group('DeparturesApp', () {
    testWidgets('should create app and show navigation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      // Use pump instead of pumpAndSettle to avoid timeout from async operations
      await tester.pump();

      // The app should have a navigation bar
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('should have four navigation destinations', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Should have 4 navigation destinations
      expect(find.byType(NavigationDestination), findsNWidgets(4));
    });

    testWidgets('should start on home page', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // First navigation destination should be selected
      final navigationBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      expect(navigationBar.selectedIndex, equals(0));
    });
  });

  group('AppMainPage', () {
    testWidgets('should navigate between pages', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Initial page should be home (index 0)
      final navigationBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      expect(navigationBar.selectedIndex, equals(0));

      // Tap on favorites (index 1)
      await tester.tap(find.byType(NavigationDestination).at(1));
      await tester.pump();

      final navigationBar2 = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      expect(navigationBar2.selectedIndex, equals(1));

      // Tap on search (index 2)
      await tester.tap(find.byType(NavigationDestination).at(2));
      await tester.pump();

      final navigationBar3 = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      expect(navigationBar3.selectedIndex, equals(2));

      // Tap on settings (index 3)
      await tester.tap(find.byType(NavigationDestination).at(3));
      await tester.pump();

      final navigationBar4 = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      expect(navigationBar4.selectedIndex, equals(3));
    });

    testWidgets('should use IndexedStack to preserve page state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Should have an IndexedStack for page management
      expect(find.byType(IndexedStack), findsOneWidget);
    });

    testWidgets('should have correct number of pages in IndexedStack', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      final indexedStack = tester.widget<IndexedStack>(
        find.byType(IndexedStack),
      );
      expect(indexedStack.children.length, equals(4));
    });
  });
}
