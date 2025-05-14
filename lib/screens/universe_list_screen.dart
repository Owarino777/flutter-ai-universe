import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/universe.dart';
import '../widgets/universe_card.dart';
import '../providers/universe_provider.dart';
import '../providers/auth_provider.dart';

class UniverseListScreen extends StatelessWidget {
  const UniverseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final universeProvider = context.read<UniverseProvider>();
    final token = context.read<AuthProvider>().token!;
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🌄 Background
          Image.asset("assets/images/background_yodai_generated.jpg", fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),

          // 🌐 Contenu
          SafeArea(
            child: FutureBuilder<List<Universe>>(
              future: universeProvider.loadUniverses(token),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.amber));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erreur : ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Aucun univers disponible.',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  );
                } else {
                  final universes = snapshot.data!;
                  return Column(
                    children: [
                      // 🎯 Titre
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Choisis ton Univers",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MedievalSharp',
                            color: Colors.amberAccent,
                            shadows: [
                              Shadow(blurRadius: 6, color: Colors.black, offset: Offset(2, 2)),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // 📜 Liste déroulante
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: scrollController,
                          child: ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: universes.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: UniverseCard(
                                  universe: universes[index],
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/character_list',
                                      arguments: universes[index],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),

          // 🔙 Bouton retour
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
    );
  }
}
