import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';

class CachedAuthImage extends StatelessWidget {
  final String imageUrl;
  final String token;
  final double height;
  final double width;
  final BoxFit fit;

  const CachedAuthImage({
    super.key,
    required this.imageUrl,
    required this.token,
    required this.height,
    required this.width,
    this.fit = BoxFit.cover,
  });

  Future<File> _fetchAndCacheImage() async {
    final customKey = Uri.parse(imageUrl).pathSegments.last;

    final cacheManager = DefaultCacheManager();
    final cachedFile = await cacheManager.getFileFromCache(customKey);

    if (cachedFile != null && await cachedFile.file.exists()) {
      return cachedFile.file;
    }

    final response = await http.get(
      Uri.parse(imageUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      await cacheManager.putFile(
        customKey,
        response.bodyBytes,
        fileExtension: 'jpg',
      );
      return await cacheManager.getSingleFile(customKey);
    } else {
      throw Exception('Erreur chargement image (${response.statusCode})');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _fetchAndCacheImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: height,
            width: width,
            color: Colors.grey.shade300,
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            height: height,
            width: width,
            color: Colors.grey.shade300,
            child: const Center(child: Icon(Icons.error, color: Colors.red)),
          );
        } else {
          return Image.file(
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
