import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Règles du Jeu")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Règles du jeu",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              "- Crée ton propre univers en lui donnant un nom, une image et une description.\n"
              "- Ajoute des personnages avec un nom, un rôle et une image.\n"
              "- Ouvre une conversation avec un personnage pour interagir avec lui.\n"
              "- L'IA générera des réponses adaptées à ton univers et ton personnage.",
              style: TextStyle(fontSize: 18),
            ),
            const Spacer(),
            CustomButton(
              text: "Créer un Univers",
              onPressed: () => Navigator.pushNamed(context, '/create_universe'),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: "Voir les Univers",
              onPressed: () => Navigator.pushNamed(context, '/universe_list'),
            ),
          ],
        ),
      ),
    );
  }
}
