import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthImage extends StatelessWidget {
  final String imageUrl;
  final String token;
  final double height;
  final double width;
  final BoxFit fit;

  const AuthImage({
    super.key,
    required this.imageUrl,
    required this.token,
    required this.height,
    required this.width,
    this.fit = BoxFit.cover,
  });

  Future<Uint8List> _fetchImageBytes() async {
    final response = await http.get(
      Uri.parse(imageUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Erreur chargement image: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _fetchImageBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              height: height,
              width: width,
              color: Colors.grey.shade300,
              child: const Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Container(
            height: height,
            width: width,
            color: Colors.grey.shade300,
            child: const Center(child: Icon(Icons.error, color: Colors.red)),
          );
        } else {
          return Image.memory(
            snapshot.data!,
            height: height,
            width: width,
            fit: fit,
          );
        }
      },
    );
  }
}
