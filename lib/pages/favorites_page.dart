import 'package:departures/provider/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({
    super.key,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(appLocalizations.navigationLabelFavorites, style: Theme.of(context).textTheme.headlineMedium,),
          )
        ),
        Expanded(
          child: Consumer<FavoritesProvider>(
            builder: (context, favProvider, child) {
              return favProvider.favorites.isEmpty
                ? Center(child: Text(appLocalizations.favoritesEmpty, textAlign: TextAlign.center, style: TextStyle(height: 1.4),))
                : ReorderableListView(
                padding: EdgeInsets.zero,
                onReorder: (oldIndex, newIndex) {
                  favProvider.moveFavorite(oldIndex, newIndex);
                },
                children: favProvider.favorites,
              );
            }
          )
        )
      ],
    );
  }
}