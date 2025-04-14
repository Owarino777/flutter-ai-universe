import 'package:flutter/material.dart';
import '../models/character.dart';

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
          ],
        ),
      ),
    );
  }
}
