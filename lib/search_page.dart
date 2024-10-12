import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(AppLocalizations.of(context)!.searchTitle, style: Theme.of(context).textTheme.headlineMedium,),
          )
        ),
        Expanded(
          child: Center(
            child: Text(AppLocalizations.of(context)!.notYetImplemented),
          )
        ),
      ],
    );
  }
}
