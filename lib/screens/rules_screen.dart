import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildRule(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$emoji  ", style: const TextStyle(fontSize: 20)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 17, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📜 Règles de l'Aventure")),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/background_yodai_generated.jpg", fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),
          FadeTransition(
            opacity: _fadeIn,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "🧙‍♂️ Bienvenue dans Yod.AI",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MedievalSharp',
                        color: Colors.amberAccent,
                        shadows: [
                          Shadow(blurRadius: 8, color: Colors.black87, offset: Offset(2, 2)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildRule("🌍", "Crée ton propre **univers** : choisis un nom, une image et décris ton monde."),
                    _buildRule("🧑‍🎤", "Ajoute des **personnages** : nom, rôle, personnalité et illustration."),
                    _buildRule("💬", "Lance une **conversation** avec un personnage de ton univers."),
                    _buildRule("🧠", "L'**IA** adapte ses réponses selon le contexte, les règles et le lore de ton monde."),
                    _buildRule("🗂️", "Tu peux créer plusieurs univers et y revenir quand tu veux."),
                    _buildRule("🎭", "Chaque personnage peut avoir une attitude, un passé et une mission différente."),
                    _buildRule("⚠️", "L’univers ne doit pas contenir de propos inappropriés ou offensants."),
                    const SizedBox(height: 32),
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
            ),
          ),
        ],
      ),
    );
  }
}
