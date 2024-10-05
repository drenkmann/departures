import 'package:flutter/material.dart';

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
            child: Text("Settings", style: Theme.of(context).textTheme.headlineMedium,),
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
