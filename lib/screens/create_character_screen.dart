import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/universe.dart';
import '../providers/auth_provider.dart';
import '../providers/universe_provider.dart';
import '../widgets/magical_loader.dart';

class CreateCharacterScreen extends StatefulWidget {
  final Universe universe;

  const CreateCharacterScreen({super.key, required this.universe});

  @override
  State<CreateCharacterScreen> createState() => _CreateCharacterScreenState();
}

class _CreateCharacterScreenState extends State<CreateCharacterScreen> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _saveCharacter() async {
    final name = _nameController.text.trim();
    final token = context.read<AuthProvider>().token!;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un nom de personnage")),
      );
      return;
    }

    // Affiche un loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const MagicalLoader(),
    );

    final newChar = await context
        .read<UniverseProvider>()
        .createCharacterForUniverse(token, widget.universe, name);

    Navigator.pop(context); // Ferme le loader

    if (newChar != null) {
      Navigator.pushReplacementNamed(
        context,
        '/character_list',
        arguments: widget.universe,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la création du personnage.")),
      );
    }
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
