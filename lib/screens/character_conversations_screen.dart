import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/conversation.dart';
import '../services/universe_service.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class CharacterConversationsScreen extends StatelessWidget {
  final Character character;

  const CharacterConversationsScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthProvider>().token!;

    return Scaffold(
      appBar: AppBar(title: Text("Conversations avec ${character.name}")),
      body: FutureBuilder<List<Conversation>>(
        future: UniverseService().fetchAllConversations(token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          final all = snapshot.data!;
          final filtered = all.where((c) => c.characterId == character.id).toList();

          if (filtered.isEmpty) {
            return const Center(child: Text("Aucune conversation pour ce personnage."));
          }

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final conv = filtered[index];
              return ListTile(
                title: Text("Conversation #${conv.id}"),
                subtitle: Text("Créée le ${conv.createdAt.toLocal()}"),
              );
            },
          );
        },
      ),
    );
  }
}
