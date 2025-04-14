import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/universe.dart';
import '../providers/universe_provider.dart';

class CreateUniverseScreen extends StatefulWidget {
  const CreateUniverseScreen({super.key});

  @override
  State<CreateUniverseScreen> createState() => _CreateUniverseScreenState();
}

class _CreateUniverseScreenState extends State<CreateUniverseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final String _selectedImage = "assets/images/default_universe.jpg";

  void _saveUniverse() {
    final name = _nameController.text.trim();
    final desc = _descriptionController.text.trim();

    if (name.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    final newUniverse = Universe(name: name, description: desc, imageUrl: _selectedImage);
    context.read<UniverseProvider>().addUniverse(newUniverse);

    Navigator.pushReplacementNamed(context, '/universe_list');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un Univers")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nom de l'Univers"),
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
              onPressed: _saveUniverse,
              child: const Text("Créer l'Univers"),
            ),
          ],
        ),
      ),
    );
  }
}
