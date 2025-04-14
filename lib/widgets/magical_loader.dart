import 'package:flutter/material.dart';

class MagicalLoader extends StatelessWidget {
  const MagicalLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.brown.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "🔮 Création magique de l’univers en cours...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "MedievalSharp",
                color: Color(0xFF4E342E),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "L’imaginaire prend forme, invoque les étoiles...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                color: Color(0xFF6D4C41),
                strokeWidth: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
