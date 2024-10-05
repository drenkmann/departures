import 'package:flutter/material.dart';

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
            child: Text("Search", style: Theme.of(context).textTheme.headlineMedium,),
          )
        ),
        const Expanded(
          child: Center(
            child: Text("Not yet implemented."),
          )
        ),
      ],
    );
  }
}
