import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// Main application title
  ///
  /// In en, this message translates to:
  /// **'Departures'**
  String get appTitle;

  /// Label for the navigation button to home
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get navigationLabelHome;

  /// Label for the navigation button to favorites
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navigationLabelFavorites;

  /// Label for the navigation button to search
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navigationLabelSearch;

  /// Label for the navigation button to settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navigationLabelSettings;

  /// Text displayed when no nearby stations were found
  ///
  /// In en, this message translates to:
  /// **'No nearby stations found.'**
  String get homeNoNearbyStations;

  /// Text displayed when location couldn't be accessed
  ///
  /// In en, this message translates to:
  /// **'Location could not be accessed.\nPlease check your permission settings and restart the app.'**
  String get locationCouldNotBeAccessed;

  /// Error reason on location permission error
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t access location:\n{error}'**
  String locationCouldNotBeAccessedReason(String error);

  /// Error title on location error
  ///
  /// In en, this message translates to:
  /// **'Location Error'**
  String get locationNotEnabledError;

  /// Text displayed when location services are not enabled
  ///
  /// In en, this message translates to:
  /// **'Location services are not enabled.'**
  String get locationNotEnabled;

  /// Error title on permissions error
  ///
  /// In en, this message translates to:
  /// **'Permissions Error'**
  String get permissionsError;

  /// Advice to enable location services
  ///
  /// In en, this message translates to:
  /// **'Please enable location services in your device settings.'**
  String get locationDisabledAdvice;

  /// Advice to grant location permissions
  ///
  /// In en, this message translates to:
  /// **'Please grant location permissions to the app in your device settings.'**
  String get locationPermissionDeniedAdvice;

  /// Advice to enable precise location services
  ///
  /// In en, this message translates to:
  /// **'Please grant precise location permissions to the app in your device settings.'**
  String get locationNotPreciseAdvice;

  /// Text displayed when precise location isn't enabled
  ///
  /// In en, this message translates to:
  /// **'Location not precise enough.'**
  String get locationNotPrecise;

  /// General error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get generalError;

  /// Error title on connection error
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// Advice to check internet connection
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get connectionErrorAdvice;

  /// Error title on HTTP error
  ///
  /// In en, this message translates to:
  /// **'HTTP Error'**
  String get httpError;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @nearbyStationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby Stations'**
  String get nearbyStationsTitle;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Label of the theme option in the settings
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeTitle;

  /// Match system theme
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// Use light theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// Use dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// Appearance section title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// Advanced section title
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get settingsSectionAdvanced;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// How far into the future to load departures
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get settingsDuration;

  /// Label of the text field for the api host to be used
  ///
  /// In en, this message translates to:
  /// **'API Host'**
  String get settingsApiHostLabel;

  /// No description provided for @settingsOpenDeviceSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'Open Device Settings'**
  String get settingsOpenDeviceSettingsButton;

  /// No description provided for @settingsOpenGithubButton.
  ///
  /// In en, this message translates to:
  /// **'Open Github'**
  String get settingsOpenGithubButton;

  /// No description provided for @settingsOpenPrivacyPolicyButton.
  ///
  /// In en, this message translates to:
  /// **'Open Privacy Policy'**
  String get settingsOpenPrivacyPolicyButton;

  /// No description provided for @settingsOpenSourceLicensesButton.
  ///
  /// In en, this message translates to:
  /// **'Show Open Source Licenses'**
  String get settingsOpenSourceLicensesButton;

  /// Placeholder for station search bar
  ///
  /// In en, this message translates to:
  /// **'Enter station name'**
  String get searchBarPlaceholder;

  /// Button to load more nearby stations
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// Label for the show actual time toggle in the settings
  ///
  /// In en, this message translates to:
  /// **'Show actual time'**
  String get settingsShowActualTimeTitle;

  /// Subtitle when the show actual time toggle is on
  ///
  /// In en, this message translates to:
  /// **'Showing actual time'**
  String get settingsShowActualTimeSubtitleOn;

  /// Subtitle when the show actual time toggle is off
  ///
  /// In en, this message translates to:
  /// **'Showing planned time'**
  String get settingsShowActualTimeSubtitleOff;

  /// Button to reset all data
  ///
  /// In en, this message translates to:
  /// **'Reset everything'**
  String get settingsReset;

  /// Confirmation dialog for resetting all settings
  ///
  /// In en, this message translates to:
  /// **'Do you really want to reset all settings and favorites? This will restart the app.'**
  String get settingsResetConfirmation;

  /// Title of the reset confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Reset everything?'**
  String get settingsResetTitle;

  /// Text displayed when no favorites are saved
  ///
  /// In en, this message translates to:
  /// **'No stations saved.\nTo save a station, swipe on it.'**
  String get favoritesEmpty;

  /// Snackbar message for undoing a favorite toggle
  ///
  /// In en, this message translates to:
  /// **'{wasSaved, select, true {Saved} false {Unsaved} other {Error updating}} {stationName}'**
  String undoFavoriteToggle(String wasSaved, String stationName);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
