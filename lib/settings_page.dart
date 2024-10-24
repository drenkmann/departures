import 'package:departures/provider/api_host_settings.dart';
import 'package:departures/provider/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _mainHostController;
  late TextEditingController _fallbackHostController;
  FocusNode mainHostFocusNode = FocusNode();
  FocusNode fallbackHostFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _mainHostController = TextEditingController();
    _fallbackHostController = TextEditingController();

    final apiHostProvider = Provider.of<ApiHostProvider>(context, listen: false);
    _mainHostController.text = apiHostProvider.mainHost;
    _fallbackHostController.text = apiHostProvider.fallbackHost;
  }

  @override
  void dispose() {
    _mainHostController.dispose();
    _fallbackHostController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(appLocalizations!.settingsTitle, style: theme.textTheme.headlineMedium,),
          )
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  appLocalizations.settingsSectionAppearance,
                  style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
                ),
              ),
              ListTile(
                title: Text(appLocalizations.settingsThemeTitle),
                trailing: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return DropdownMenu(
                      initialSelection: themeProvider.themeMode,
                      inputDecorationTheme: InputDecorationTheme(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        constraints: BoxConstraints.tight(const Size.fromHeight(40)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                          value: ThemeMode.system,
                          label: appLocalizations.settingsThemeSystem
                        ),
                        DropdownMenuEntry(
                          value: ThemeMode.dark,
                          label: appLocalizations.settingsThemeDark
                        ),
                        DropdownMenuEntry(
                          value: ThemeMode.light,
                          label: appLocalizations.settingsThemeLight
                        ),
                      ],
                      onSelected: (ThemeMode? themeMode) {
                        if (themeMode != null) {
                          themeProvider.setThemeMode(themeMode);
                        }
                      },
                    );
                  }
                ),
              ),
              const Divider(
                indent: 16,
                endIndent: 16,
                height: 24,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  appLocalizations.settingsSectionAdvanced,
                  style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
                ),
              ),
              ListTile(
                title: Consumer<ApiHostProvider>(
                  builder: (context, apiHostProvider, child) {
                    _mainHostController.text = apiHostProvider.mainHost;

                    return TextFormField(
                      controller: _mainHostController,
                      focusNode: mainHostFocusNode,
                      onTapOutside: (event) {
                        mainHostFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        apiHostProvider.saveMainHostPreference(value);
                      },
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: appLocalizations.settingsMainHostLabel,
                      ),
                    );
                  }
                ),
              ),
              ListTile(
                title: Consumer<ApiHostProvider>(
                  builder: (context, apiHostProvider, child) {
                    _fallbackHostController.text = apiHostProvider.fallbackHost;

                    return TextFormField(
                      controller: _fallbackHostController,
                      focusNode: fallbackHostFocusNode,
                      onTapOutside: (event) {
                        fallbackHostFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        apiHostProvider.saveFallbackHostPreferences(value);
                      },
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: appLocalizations.settingsFallbackHostLabel,
                      ),
                    );
                  }
                ),
              ),
              const Divider(
                indent: 16,
                endIndent: 16,
                height: 24,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  appLocalizations.settingsSectionAbout,
                  style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
                ),
              ),
              ListTile(
                title: Text(appLocalizations.settingsAboutAppButton),
                trailing: const Icon(Icons.info_outline),
                onTap: () {
                  PackageInfo.fromPlatform().then((PackageInfo info) {
                    if (!context.mounted) return;

                    showAboutDialog(
                      context: context,
                      applicationName: appLocalizations.appTitle,
                      applicationVersion: "v${info.version}",
                      applicationLegalese: "© drenkmann 2024",
                    );
                  });
                },
              ),
              ListTile(
                title: const Text("Open Github"),
                trailing: const Icon(Icons.code_outlined),
                onTap: () async {
                  if (!await launchUrlString("https://github.com/drenkmann/departures")) {
                    throw Exception("Could not open github URL");
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
