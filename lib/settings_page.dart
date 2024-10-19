import 'package:departures/provider/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(appLocalizations!.settingsTitle, style: Theme.of(context).textTheme.headlineMedium,),
          )
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: Text(appLocalizations.settingsThemeTitle),
                trailing: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return DropdownMenu(
                      initialSelection: themeProvider.themeMode,
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
            ],
          ),
        )
      ],
    );
  }
}
