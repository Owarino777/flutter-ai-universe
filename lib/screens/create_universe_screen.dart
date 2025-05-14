import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/universe_provider.dart';
import '../widgets/magical_loader.dart';
import '../widgets/custom_button.dart';

class CreateUniverseScreen extends StatefulWidget {
  const CreateUniverseScreen({super.key});

  @override
  State<CreateUniverseScreen> createState() => _CreateUniverseScreenState();
}

class _CreateUniverseScreenState extends State<CreateUniverseScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveUniverse() async {
    final name = _nameController.text.trim();
    final token = context.read<AuthProvider>().token!;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un nom")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const MagicalLoader(),
    );

    try {
      final created = await context.read<UniverseProvider>().createUniverse(token, name);
      Navigator.pop(context); // Fermer le loader

      if (created != null) {
        Navigator.pushReplacementNamed(context, '/universe_list');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la création de l'univers.")),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      prefixIcon: const Icon(Icons.public, color: Colors.amberAccent),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.amberAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/background_yodai_generated.jpg", fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.65)),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              tooltip: "Retour",
              onPressed: () => Navigator.pop(context),
            ),
          ),

          Center(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Créer un Univers",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MedievalSharp',
                          color: Colors.amberAccent,
                          shadows: [
                            Shadow(blurRadius: 8, color: Colors.black87, offset: Offset(2, 2)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration("Nom de l'univers"),
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        text: "Créer l'Univers",
                        onPressed: _saveUniverse,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
