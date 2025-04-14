import 'package:flutter/material.dart';
import '../models/universe.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/cached_auth_image.dart';

class UniverseCard extends StatelessWidget {
  final Universe universe;
  final VoidCallback onTap;

  const UniverseCard({super.key, required this.universe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthProvider>().token!;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            universe.image != null && universe.image!.isNotEmpty
                ? CachedAuthImage(
              imageUrl: "https://yodai.wevox.cloud/image_data/${universe.image}",
              token: token,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : Container(height: 180, color: Colors.grey),
            Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Colors.black.withValues(), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              child: Text(
                universe.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(blurRadius: 4, color: Colors.black, offset: Offset(2, 2)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
