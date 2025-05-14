import 'package:flutter/material.dart';
import 'package:project/widgets/custom_button.dart';
import 'package:project/widgets/rpg_transition.dart';
import 'package:project/screens/register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeTitle;
  late Animation<double> _fadeButtons;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _fadeTitle = CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeOut));
    _fadeButtons = CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🌄 Background image
          Image.asset(
            "assets/images/background_yodai_generated.jpg",
            fit: BoxFit.cover,
          ),

          // 🌫️ Glass-like overlay
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              backgroundBlendMode: BlendMode.darken,
            ),
          ),

          // ✨ Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔮 Title with animation
                    FadeTransition(
                      opacity: _fadeTitle,
                      child: Text(
                        "Bienvenue dans Yod.AI",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'MedievalSharp',
                          shadows: [
                            Shadow(blurRadius: 8, color: Colors.black87, offset: Offset(2, 2)),
                            Shadow(blurRadius: 20, color: Colors.orangeAccent, offset: Offset(0, 0)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),

                    // 🎮 Buttons with animation
                    FadeTransition(
                      opacity: _fadeButtons,
                      child: Column(
                        children: [
                          CustomButton(
                            text: "Démarrer l'Aventure",
                            onPressed: () => Navigator.of(context).push(
                              buildRpgRoute(const RegisterScreen(), type: TransitionType.scale),
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: "Continuer l'Aventure",
                            onPressed: () => Navigator.pushNamed(context, '/login'),
                          ),
                        ],
                      ),
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
