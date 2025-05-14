import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../models/character.dart';
import '../models/conversation.dart';

import '../services/universe_service.dart';

import '../widgets/custom_button.dart';
import '../widgets/cached_auth_image.dart';

import '../providers/auth_provider.dart';

import 'character_conversations_screen.dart';
import 'chat_screen.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthProvider>().token!;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/background_yodai_generated.jpg", fit: BoxFit.cover),
          Container(color: const Color.fromARGB(153, 0, 0, 0)),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: character.imageUrl.startsWith("http")
                        ? CachedAuthImage(
                      imageUrl: character.imageUrl,
                      token: token,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : CachedAuthImage(
                      imageUrl: "https://yodai.wevox.cloud/image_data/${character.imageUrl}",
                      token: token,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    character.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MedievalSharp',
                      color: Colors.amberAccent,
                      shadows: [
                        Shadow(blurRadius: 6, color: Colors.black, offset: Offset(2, 2)),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    character.description,
                    style: const TextStyle(fontSize: 18, height: 1.5, color: Colors.white70),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: "📜 Voir les conversations",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CharacterConversationsScreen(character: character),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: "💬 Discuter avec ${character.name}",
                    onPressed: () async {
                      final authProvider = context.read<AuthProvider>();
                      final token = authProvider.token;
                      final userId = authProvider.userId;

                      if (token == null || userId == null) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Utilisateur non authentifié.")),
                        );
                        return;
                      }

                      // Charger les conversations avant le test
                      final all = await UniverseService().fetchAllConversations(token);
                      if (!context.mounted) return;

                      // Vérifier si une conversation existe déjà
                      final existing = all.firstWhereOrNull(
                            (c) => c.characterId == character.id && c.userId == userId,
                      );

                      Conversation conversation;

                      if (existing != null) {
                        conversation = existing;
                      } else {
                        final created = await UniverseService().createConversation(token, character.id, userId);
                        if (!context.mounted) return;

                        if (created == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Erreur de création.")),
                          );
                          return;
                        }
                        conversation = created;
                      }

                      if (!context.mounted) return;

                      // Aller à l'écran de chat
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            conversation: conversation,
                            character: character,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              tooltip: "Retour",
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
