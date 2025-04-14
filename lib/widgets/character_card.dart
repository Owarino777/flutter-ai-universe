import 'package:flutter/material.dart';
import '../models/character.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            character.imageUrl.startsWith("http")
                ? Image.network(
              character.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : Image.network(
              "https://yodai.wevox.cloud/image_data/${character.imageUrl}",
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withValues(), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                character.name,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(blurRadius: 6, color: Colors.black),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
