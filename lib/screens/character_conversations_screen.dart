import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../models/conversation.dart';
import '../providers/auth_provider.dart';
import '../services/universe_service.dart';
import 'chat_screen.dart';

class CharacterConversationsScreen extends StatelessWidget {
  final Character character;

  const CharacterConversationsScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthProvider>().token!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Conversations avec ${character.name}"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: FutureBuilder<List<Conversation>>(
        future: UniverseService().fetchAllConversations(token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}", style: TextStyle(color: Colors.red)));
          }

          final conversations = snapshot.data!
              .where((c) => c.characterId == character.id)
              .toList();

          if (conversations.isEmpty) {
            return const Center(child: Text("Aucune conversation avec ce personnage.", style: TextStyle(fontSize: 18, color: Colors.grey)));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            itemCount: conversations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final conv = conversations[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        conversation: conv,
                        character: character,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.1 * 255).round()),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.message, color: Colors.deepPurple, size: 30),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Conversation #${conv.id}",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Créée le ${conv.createdAt.toLocal()}",
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple, size: 16),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
