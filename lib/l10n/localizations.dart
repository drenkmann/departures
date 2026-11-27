import 'package:material_ui/material_ui.dart';

import 'app_localizations.dart';

// gen-l10n still emits flutter_localizations delegates; material_ui widgets need their own.
const List<LocalizationsDelegate<dynamic>> appLocalizationsDelegates =
    <LocalizationsDelegate<dynamic>>[
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ];
