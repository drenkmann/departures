import 'package:departures/provider/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(AppLocalizations.of(context)!.settingsTitle, style: Theme.of(context).textTheme.headlineMedium,),
          )
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: const Text("Theme"),
                trailing: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return DropdownMenu(
                      initialSelection: themeProvider.themeMode,
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(
                          value: ThemeMode.system,
                          label: "System"
                        ),
                        DropdownMenuEntry(
                          value: ThemeMode.dark,
                          label: "Dark"
                        ),
                        DropdownMenuEntry(
                          value: ThemeMode.light,
                          label: "Light"
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
