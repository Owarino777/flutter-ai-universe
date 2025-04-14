import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/universe_provider.dart';
import '../widgets/magical_loader.dart';

class CreateUniverseScreen extends StatefulWidget {
  const CreateUniverseScreen({super.key});

  @override
  State<CreateUniverseScreen> createState() => _CreateUniverseScreenState();
}

class _CreateUniverseScreenState extends State<CreateUniverseScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _saveUniverse() async{
    final name = _nameController.text.trim();
    final token = context.read<AuthProvider>().token!;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un nom")),
      );
      return;
    }

    // Affiche un loader plein écran
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const MagicalLoader(),
    );

    try {
      final created = await context.read<UniverseProvider>().createUniverse(
        token,
        name,
      );

      Navigator.pop(context); // Fermer le loader

      if (created != null) {
        Navigator.pushReplacementNamed(context, '/universe_list');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la création de l'univers.")),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Fermer le loader même en cas d’erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
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
