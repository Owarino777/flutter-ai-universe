import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/character.dart';
import '../models/universe.dart';
import '../providers/auth_provider.dart';
import '../providers/universe_provider.dart';
import '../widgets/character_card.dart';

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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/background_yodai_generated.jpg", fit: BoxFit.cover),
          Container(color: const Color.fromARGB(153, 0, 0, 0)),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Personnages de ${widget.universe.name}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MedievalSharp',
                      color: Colors.amberAccent,
                      shadows: [
                        Shadow(blurRadius: 6, color: Colors.black, offset: Offset(2, 2)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Character>>(
                    future: _futureCharacters,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Colors.amber));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Erreur : ${snapshot.error}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "Aucun personnage trouvé.",
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      } else {
                        final characters = snapshot.data!;
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: characters.length,
                          itemBuilder: (context, index) {
                            return CharacterCard(
                              character: characters[index],
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/character_detail',
                                  arguments: characters[index],
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              tooltip: "Retour",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/create_character',
            arguments: widget.universe,
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
