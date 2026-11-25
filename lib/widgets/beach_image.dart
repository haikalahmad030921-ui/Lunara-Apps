import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BeachImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const BeachImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _PlaceholderBox(width: width, height: height);
      },
      errorBuilder: (context, error, stackTrace) {
        return _PlaceholderBox(width: width, height: height);
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }
    return image;
  }
}

class _PlaceholderBox extends StatelessWidget {
  final double? width;
  final double? height;

  const _PlaceholderBox({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryContainer,
            AppColors.primary,
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.landscape_rounded,
          color: AppColors.onPrimaryContainer,
          size: 32,
        ),
      ),
    );
  }
}
