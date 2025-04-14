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
      appBar: AppBar(title: const Text("Sélectionne un Univers")),
      body: FutureBuilder<List<Universe>>(
        future: universeProvider.loadUniverses(token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun univers disponible.'));
          } else {
            final universes = snapshot.data!;
            return Scrollbar(
              thumbVisibility: true,
              controller: scrollController,
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: universes.length,
                itemBuilder: (context, index) {
                  return UniverseCard(
                    universe: universes[index],
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/character_list',
                        arguments: universes[index],
                      );
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}