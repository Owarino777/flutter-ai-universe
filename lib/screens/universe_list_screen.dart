import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/universe_card.dart';
import '../providers/universe_provider.dart';

class UniverseListScreen extends StatelessWidget {
  const UniverseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final universes = context.watch<UniverseProvider>().universes;

    return Scaffold(
      appBar: AppBar(title: const Text("Sélectionne un Univers")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: universes.length,
          itemBuilder: (context, index) {
            return UniverseCard(
              universe: universes[index],
              onTap: () {
                Navigator.pushNamed(context, '/create_character', arguments: universes[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
