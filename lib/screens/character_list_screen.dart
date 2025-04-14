import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/universe.dart';
import '../providers/universe_provider.dart';

class CharacterListScreen extends StatelessWidget {
  final Universe universe;

  const CharacterListScreen({super.key, required this.universe});

  @override
  Widget build(BuildContext context) {
    final allUniverses = context.watch<UniverseProvider>().universes;
    final selected = allUniverses.firstWhere((u) => u.name == universe.name);
    final characters = selected.characters;

    return Scaffold(
      appBar: AppBar(title: Text("Personnages de ${universe.name}")),
      body: ListView.builder(
        itemCount: characters.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(characters[index].imageUrl),
            ),
            title: Text(characters[index].name),
            subtitle: Text(characters[index].description),
            onTap: () {
              Navigator.pushNamed(context, '/chat', arguments: characters[index]);
            },
          );
        },
      ),
    );
  }
}
