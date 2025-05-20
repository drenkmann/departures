// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Abfahrten';

  @override
  String get navigationLabelHome => 'In der Nähe';

  @override
  String get navigationLabelFavorites => 'Gespeichert';

  @override
  String get navigationLabelSearch => 'Suchen';

  @override
  String get navigationLabelSettings => 'Einstellungen';

  @override
  String get homeNoNearbyStations => 'Keine Stationen in der Nähe gefunden.';

  @override
  String get locationCouldNotBeAccessed => 'Standort konnte nicht ermittelt werden.\nBitte überprüfe die App Berechtigungen und starte die App neu.';

  @override
  String locationCouldNotBeAccessedReason(String error) {
    return 'Standort konnte nicht ermittelt werden:\n$error';
  }

  @override
  String get locationNotEnabledError => 'Standort Fehler';

  @override
  String get locationNotEnabled => 'Standort Dienste sind nicht aktiviert.';

  @override
  String get permissionsError => 'Berechtigungs Fehler';

  @override
  String get locationDisabledAdvice => 'Bitte aktiviere Standort Dienste in den Geräte Einstellungen.';

  @override
  String get locationPermissionDeniedAdvice => 'Bitte gewähre der App Standort Berechtigungen in den Geräte Einstellungen.';

  @override
  String get locationNotPreciseAdvice => 'Bitte aktiviere der App genaue Standort Berechtigungen in den Geräte Einstellungen.';

  @override
  String get locationNotPrecise => 'Standort nicht genau genug.';

  @override
  String get generalError => 'Fehler';

  @override
  String get connectionError => 'Verbindungsfehler';

  @override
  String get connectionErrorAdvice => 'Bitte überprüfe deine Internetverbindung.';

  @override
  String get httpError => 'HTTP Fehler';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Schließen';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get undo => 'Zurück';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get nearbyStationsTitle => 'Stationen in der Nähe';

  @override
  String get searchTitle => 'Suchen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsThemeTitle => 'Farbschema';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsSectionAppearance => 'Aussehen';

  @override
  String get settingsSectionAdvanced => 'Experten';

  @override
  String get settingsSectionAbout => 'Über';

  @override
  String get settingsDuration => 'Dauer';

  @override
  String get settingsApiHostLabel => 'API Host';

  @override
  String get settingsOpenDeviceSettingsButton => 'Geräte Einstellungen öffnen';

  @override
  String get settingsOpenGithubButton => 'Github öffnen';

  @override
  String get settingsOpenPrivacyPolicyButton => 'Datenschutzrichtlinie öffnen';

  @override
  String get settingsOpenSourceLicensesButton => 'Open Source Lizenzen anzeigen';

  @override
  String get searchBarPlaceholder => 'Haltestelle eingeben';

  @override
  String get loadMore => 'Mehr laden';

  @override
  String get settingsShowActualTimeTitle => 'Tatsächliche Zeit anzeigen';

  @override
  String get settingsShowActualTimeSubtitleOn => 'Zeigt tatsächliche Zeit';

  @override
  String get settingsShowActualTimeSubtitleOff => 'Zeigt geplante Zeit';

  @override
  String get settingsReset => 'Alles zurücksetzen';

  @override
  String get settingsResetConfirmation => 'Sind Sie sicher, dass Sie alle Einstellungen und gespeicherte Stationen zurücksetzen möchten? Die App wird danach neusstarten.';

  @override
  String get settingsResetTitle => 'Alles zurücksetzen?';

  @override
  String get favoritesEmpty => 'Keine Stationen gespeichert.\nUm eine Station zu speichern, wische zur Seite.';

  @override
  String undoFavoriteToggle(String wasSaved, String stationName) {
    String _temp0 = intl.Intl.selectLogic(
      wasSaved,
      {
        'true': 'gespeichert',
        'false': 'entfernt',
        'other': 'Update fehlgeschlagen',
      },
    );
    return '$stationName $_temp0.';
  }
}
