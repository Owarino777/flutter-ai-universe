import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/character.dart';
import '../models/universe.dart';
import '../providers/auth_provider.dart';
import '../providers/universe_provider.dart';

class CharacterListScreen extends StatefulWidget {
  final Universe universe;

  const CharacterListScreen({super.key, required this.universe});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  late Future<List<Character>> _futureCharacters;

  @override
  void initState() {
    super.initState();
    final token = context.read<AuthProvider>().token!;
    _futureCharacters = context
        .read<UniverseProvider>()
        .loadCharactersForUniverse(token, widget.universe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Personnages de ${widget.universe.name}")),
      body: FutureBuilder<List<Character>>(
        future: _futureCharacters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun personnage trouvé."));
          } else {
            final characters = snapshot.data!;
            return ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final char = characters[index];
                return ListTile(
                  leading: char.imageUrl.startsWith("http")
                      ? Image.network(char.imageUrl, width: 50, height: 50)
                      : Image.network(
                    "https://yodai.wevox.cloud/image_data/${char.imageUrl}",
                    width: 50,
                    height: 50,
                  ),
                  title: Text(char.name),
                  subtitle: Text(char.description),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/create_character',
            arguments: widget.universe,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
