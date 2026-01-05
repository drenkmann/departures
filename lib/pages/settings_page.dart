import 'package:departures/provider/api_settings_provider.dart';
import 'package:departures/enums/app_theme_modes.dart';
import 'package:departures/provider/distance_settings_provider.dart';
import 'package:departures/provider/theme_settings_provider.dart';
import 'package:departures/provider/time_display_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:departures/l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _mainHostController;
  FocusNode mainHostFocusNode = FocusNode();
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();

    _mainHostController = TextEditingController();
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        _packageInfo = packageInfo;
      });
    });

    final apiHostProvider = Provider.of<ApiSettingsProvider>(
      context,
      listen: false,
    );
    _mainHostController.text = apiHostProvider.mainHost;
  }

  @override
  void dispose() {
    _mainHostController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 8,
          children: [
            Text(
              AppLocalizations.of(context)!.settingsTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              appLocalizations.settingsSectionAppearance,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          ListTile(
            title: Text(appLocalizations.settingsThemeTitle),
            trailing: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return DropdownMenu(
                  initialSelection: themeProvider.appThemeMode,
                  inputDecorationTheme: InputDecorationTheme(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    constraints: BoxConstraints.tight(
                      const Size.fromHeight(40),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(
                      value: AppThemeMode.system,
                      label: appLocalizations.settingsThemeSystem,
                    ),
                    DropdownMenuEntry(
                      value: AppThemeMode.dark,
                      label: appLocalizations.settingsThemeDark,
                    ),
                    DropdownMenuEntry(
                      value: AppThemeMode.light,
                      label: appLocalizations.settingsThemeLight,
                    ),
                    DropdownMenuEntry(
                      value: AppThemeMode.you,
                      label: "Material You",
                    ),
                  ],
                  onSelected: (AppThemeMode? themeMode) {
                    if (themeMode != null) {
                      themeProvider.setThemeMode(themeMode);
                    }
                  },
                );
              },
            ),
          ),
          Consumer<TimeDisplaySettingsProvider>(
            builder: (context, timeDisplayProvider, child) => ListTile(
              title: Text(appLocalizations.settingsShowActualTimeTitle),
              subtitle: timeDisplayProvider.showActualTime
                  ? Text(appLocalizations.settingsShowActualTimeSubtitleOn)
                  : Text(appLocalizations.settingsShowActualTimeSubtitleOff),
              trailing: Switch(
                value: timeDisplayProvider.showActualTime,
                onChanged: (value) {
                  timeDisplayProvider.setShowActualTime(value);
                },
              ),
            ),
          ),
          Consumer<DistanceSettingsProvider>(
            builder: (context, distanceSettingsProvider, child) => ListTile(
              title: Text(appLocalizations.settingsShowDistanceTitle),
              subtitle: distanceSettingsProvider.showDistance
                  ? Text(appLocalizations.settingsShowDistanceSubtitleOn)
                  : Text(appLocalizations.settingsShowDistanceSubtitleOff),
              trailing: Switch(
                value: distanceSettingsProvider.showDistance,
                onChanged: (value) {
                  distanceSettingsProvider.setShowDistance(value);
                },
              ),
            ),
          ),
          const Divider(indent: 16, endIndent: 16, height: 24, thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              appLocalizations.settingsSectionAdvanced,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Consumer<ApiSettingsProvider>(
            builder: (context, apiHostProvider, child) {
              _mainHostController.text = apiHostProvider.mainHost;

              return Column(
                children: [
                  ListTile(
                    title: Text("Duration"),
                    subtitle: Slider(
                      min: 10,
                      max: 120,
                      divisions: 11,
                      label: "${apiHostProvider.duration}min.",
                      value: apiHostProvider.duration.toDouble(),
                      onChanged: (value) {
                        apiHostProvider.setDuration(value.toInt());
                      },
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      controller: _mainHostController,
                      focusNode: mainHostFocusNode,
                      onTapOutside: (event) {
                        mainHostFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        apiHostProvider.saveHost(value);
                      },
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        hintText: "v6.vbb.transport.rest",
                        labelText: appLocalizations.settingsApiHostLabel,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          ListTile(
            title: Text(appLocalizations.settingsReset),
            trailing: const Icon(Icons.restart_alt_outlined),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(appLocalizations.settingsResetTitle),
                  content: Text(appLocalizations.settingsResetConfirmation),
                  actions: [
                    TextButton(
                      onPressed: () {
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.clear().then((_) => Restart.restartApp());
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text(appLocalizations.yes),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(appLocalizations.no),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(indent: 16, endIndent: 16, height: 24, thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              appLocalizations.settingsSectionAbout,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          ListTile(
            title: Text("Support the developer"),
            trailing: Icon(Icons.coffee_outlined),
            onTap: () async {
              if (!await launchUrlString("https://ko-fi.com/drenkmann")) {
                throw Exception("Could not open ko-fi URL");
              }
            },
          ),
          ListTile(
            title: Text(appLocalizations.settingsOpenGithubButton),
            trailing: const Icon(Icons.code_outlined),
            onTap: () async {
              if (!await launchUrlString(
                "https://github.com/drenkmann/departures",
              )) {
                throw Exception("Could not open github URL");
              }
            },
          ),
          ListTile(
            title: Text(appLocalizations.settingsOpenPrivacyPolicyButton),
            trailing: const Icon(Icons.privacy_tip_outlined),
            onTap: () async {
              if (!await launchUrlString(
                "https://github.com/drenkmann/departures",
              )) {
                throw Exception("Could not open github URL");
              }
            },
          ),
          ListTile(
            title: Text(appLocalizations.settingsOpenDeviceSettingsButton),
            trailing: const Icon(Icons.settings_outlined),
            onTap: Geolocator.openAppSettings,
          ),
          ListTile(
            title: Text(appLocalizations.settingsOpenSourceLicensesButton),
            trailing: const Icon(Icons.description_outlined),
            onTap: () => showLicensePage(context: context),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "v${_packageInfo?.version ?? ""} - © drenkmann 2025",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
