import 'dart:io';
import 'package:flutter/material.dart';

class ProductImageWidget extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;

  const ProductImageWidget({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Check if it's an asset or a file path
    if (imagePath.startsWith('assets/')) {
      // It's an asset
      return Image.asset(
        imagePath,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          return _ErrorPlaceholder(width: width, height: height);
        },
      );
    } else {
      // It's a file path
      final file = File(imagePath);
      return Image.file(
        file,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          return _ErrorPlaceholder(width: width, height: height);
        },
      );
    }
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;

  const _ErrorPlaceholder({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 48, color: Colors.grey[600]),
          const SizedBox(height: 8),
          Text(
            'Gambar tidak\ntersedia',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
