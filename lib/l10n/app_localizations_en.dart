// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Departures';

  @override
  String get navigationLabelHome => 'Nearby';

  @override
  String get navigationLabelFavorites => 'Saved';

  @override
  String get navigationLabelSearch => 'Search';

  @override
  String get navigationLabelSettings => 'Settings';

  @override
  String get homeNoNearbyStations => 'No nearby stations found.';

  @override
  String get locationCouldNotBeAccessed =>
      'Location could not be accessed.\nPlease check your permission settings and restart the app.';

  @override
  String locationCouldNotBeAccessedReason(String error) {
    return 'Couldn\'t access location:\n$error';
  }

  @override
  String get locationNotEnabledError => 'Location Error';

  @override
  String get locationNotEnabled => 'Location services are not enabled.';

  @override
  String get permissionsError => 'Permissions Error';

  @override
  String get locationDisabledAdvice =>
      'Please enable location services in your device settings.';

  @override
  String get locationPermissionDeniedAdvice =>
      'Please grant location permissions to the app in your device settings.';

  @override
  String get locationNotPreciseAdvice =>
      'Please grant precise location permissions to the app in your device settings.';

  @override
  String get locationNotPrecise => 'Location not precise enough.';

  @override
  String get generalError => 'Error';

  @override
  String get connectionError => 'Connection Error';

  @override
  String get connectionErrorAdvice =>
      'Please check your internet connection and try again.';

  @override
  String get httpError => 'HTTP Error';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Close';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get undo => 'Undo';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get nearbyStationsTitle => 'Nearby Stations';

  @override
  String get searchTitle => 'Search';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsThemeTitle => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsSectionAdvanced => 'Advanced';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsDuration => 'Duration';

  @override
  String get settingsApiHostLabel => 'API Host';

  @override
  String get settingsOpenDeviceSettingsButton => 'Open Device Settings';

  @override
  String get settingsOpenGithubButton => 'Open Github';

  @override
  String get settingsOpenPrivacyPolicyButton => 'Open Privacy Policy';

  @override
  String get settingsOpenSourceLicensesButton => 'Show Open Source Licenses';

  @override
  String get searchBarPlaceholder => 'Enter station name';

  @override
  String get loadMore => 'Load more';

  @override
  String get settingsShowActualTimeTitle => 'Show actual time';

  @override
  String get settingsShowActualTimeSubtitleOn => 'Showing actual time';

  @override
  String get settingsShowActualTimeSubtitleOff => 'Showing planned time';

  @override
  String get settingsReset => 'Reset everything';

  @override
  String get settingsResetConfirmation =>
      'Do you really want to reset all settings and favorites? This will restart the app.';

  @override
  String get settingsResetTitle => 'Reset everything?';

  @override
  String get favoritesEmpty =>
      'No stations saved.\nTo save a station, swipe on it.';

  @override
  String undoFavoriteToggle(String wasSaved, String stationName) {
    String _temp0 = intl.Intl.selectLogic(wasSaved, {
      'true': 'Saved',
      'false': 'Unsaved',
      'other': 'Error updating',
    });
    return '$_temp0 $stationName';
  }
}
