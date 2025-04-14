import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/background_yodai_generated.jpg", fit: BoxFit.cover),
          Container(
            color: const Color(0xFF000000).withValues(red: 0, green: 0, blue: 0, alpha: 0),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Bienvenue dans Yod.AI",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(blurRadius: 8, color: Colors.black54, offset: Offset(2, 2))
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Démarrer l'Aventure (Inscription)
                  CustomButton(
                    text: "Démarrer l'Aventure",
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                  ),
                  const SizedBox(height: 20),

                  // Continuer l'Aventure (Connexion)
                  CustomButton(
                    text: "Continuer l'Aventure",
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
