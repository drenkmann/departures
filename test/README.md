# Unit Tests

## Disclaimer
These tests were written using AI. I did, however, go over every single file and test. These tests are far from perfect, but they are better than nothing. DO NOT RELY ON THESE TESTS FOR TEST DRIVEN DEVELOPMENT. They are not covering everything and they weren't written in anticipation of new features. They soley exist as a baseline check to verify that no existing functionality was broken.

If any of these tests fail, something is either VERY broken, or the core of the codebase was changed in a way that requires further attention and rewriting of the tests.

## Test Structure

The tests are organized by component type:

### Enums (`test/enums/`)
- `app_theme_modes_test.dart` - Tests for the AppThemeMode enum, verifying theme mode mappings
- `line_types_test.dart` - Tests for the LineType enum, verifying colors for each transport line type

### Services (`test/services/`)
- `api_test.dart` - Tests for VbbApi service methods, particularly ISO 8601 date/time conversion
- `stop_test.dart` - Tests for Stop, StationLocation, Products, Lines, and Color data models
- `departure_test.dart` - Tests for Departure, Line, Operator, Remarks, and CurrentTripPosition data models

### Providers (`test/provider/`)
- `theme_settings_provider_test.dart` - Tests for ThemeProvider state management
- `api_settings_provider_test.dart` - Tests for ApiSettingsProvider state management
- `time_display_settings_provider_test.dart` - Tests for TimeDisplaySettingsProvider state management
- `favorites_provider_test.dart` - Tests for FavoritesProvider state management and persistence

### Widgets (`test/widgets/`)
- `bus_display_test.dart` - Tests for BusDisplay widget rendering and behavior
- `station_display_test.dart` - Tests for StationDisplay and LineTag widgets

### Main App (`test/`)
- `widget_test.dart` - Integration tests for the main app navigation and structure

## Test Coverage

The test suite covers:

1. **Enums** - All enum values and their associated properties
2. **Data Models** - JSON serialization/deserialization for all models
3. **Providers** - State management, SharedPreferences persistence, and listener notifications
4. **Widgets** - Widget rendering, user interactions, and visual properties
5. **Services** - Utility methods and data transformations
6. **Main App** - Navigation flow and app structure

## Key Testing Patterns

- **Mock SharedPreferences**: Tests use `SharedPreferences.setMockInitialValues()` to mock persistence
- **Widget Testing**: Uses `WidgetTester` with `pumpWidget` and `pumpAndSettle`
- **Provider Testing**: Tests use `ChangeNotifierProvider` and verify listener notifications
- **Async Testing**: Providers that load data asynchronously include appropriate delays for completion

## Test Assertions

Tests verify:
- Correct values are returned
- State changes trigger listener notifications
- Data is properly persisted to SharedPreferences
- Widgets render correctly with expected properties
- JSON serialization maintains data integrity
- Edge cases and null values are handled properly
