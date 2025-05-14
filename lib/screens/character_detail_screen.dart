import 'package:flutter/material.dart';
import '../models/character.dart';
import 'character_conversations_screen.dart';
import '../widgets/custom_button.dart';
import '../providers/auth_provider.dart';
import '../models/conversation.dart';
import '../services/universe_service.dart';
import 'package:provider/provider.dart';
import 'chat_screen.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(character.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            character.imageUrl.startsWith("http")
                ? Image.network(character.imageUrl, height: 300, width: double.infinity, fit: BoxFit.cover)
                : Image.network("https://yodai.wevox.cloud/image_data/${character.imageUrl}", height: 300, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                character.description,
                style: const TextStyle(fontSize: 18, height: 1.5),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomButton(
                text: "Voir la conversations",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CharacterConversationsScreen(character: character),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomButton(
                text: "Discuter avec ${character.name}",
                onPressed: () async {
                  final authProvider = context.read<AuthProvider>();
                  final token = authProvider.token;
                  final userId = authProvider.userId;

                  if (token == null || userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Utilisateur non authentifié.")),
                    );
                    return;
                  }

                  final all = await UniverseService().fetchAllConversations(token);

                  Conversation? existing;
                  for (final c in all) {
                    if (c.characterId == character.id && c.userId == userId) {
                      existing = c;
                      break;
                    }
                  }

                  Conversation conversation;
                  if (existing != null) {
                    conversation = existing;
                  } else {
                    final created = await UniverseService().createConversation(token, character.id, userId);
                    if (created == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erreur de création.")));
                      return;
                    }
                    conversation = created;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(conversation: conversation, character: character),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
