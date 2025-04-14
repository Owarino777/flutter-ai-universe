import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/universe.dart';
import '../models/character.dart';
import '../providers/universe_provider.dart';

class CreateCharacterScreen extends StatefulWidget {
  final Universe universe;

  const CreateCharacterScreen({super.key, required this.universe});

  @override
  State<CreateCharacterScreen> createState() => _CreateCharacterScreenState();
}

class _CreateCharacterScreenState extends State<CreateCharacterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final String _selectedImage = "assets/images/default_character.jpg";

  void _saveCharacter() {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    final character = Character(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: _selectedImage,
    );

    context.read<UniverseProvider>().addCharacterToUniverse(widget.universe, character);

    Navigator.pushReplacementNamed(context, '/character_list', arguments: widget.universe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un personnage pour ${widget.universe.name}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nom du personnage"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Image.asset(_selectedImage, height: 150),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCharacter,
              child: const Text("Créer le personnage"),
            ),
          ],
        ),
      ),
    );
  }
}
