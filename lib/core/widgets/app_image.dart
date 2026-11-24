import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

/// Shows a photo from `assets/images/` or from a URL.
///
/// If the asset file hasn't been added yet (or a URL fails), it shows a grey
/// [ImagePlaceholder] with the file name, instead of crashing.
class AppImage extends StatelessWidget {
  const AppImage(
    this.source, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.semanticLabel,
  });

  /// An asset path (`assets/images/...`) or an `http(s)` URL.
  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    Widget fallback(BuildContext context, Object error, StackTrace? stackTrace) =>
        ImagePlaceholder(width: width, height: height, label: source.split('/').last);

    if (source.startsWith('http://') || source.startsWith('https://')) {
      return Image.network(
        source,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        semanticLabel: semanticLabel,
        errorBuilder: fallback,
      );
    }
    return Image.asset(
      source,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      semanticLabel: semanticLabel,
      errorBuilder: fallback,
    );
  }
}

/// Grey box shown where a photo will go.
class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key, this.width, this.height, this.label});

  final double? width;
  final double? height;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: AppColors.sand,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add_photo_alternate_outlined, color: AppColors.muted, size: 22),
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                label!,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body(size: 10, color: AppColors.muted),
              ),
            ),
        ],
      ),
    );
  }
}

/// A photo in a white polaroid frame, optionally tilted, with a handwritten
/// caption.
class PolaroidPhoto extends StatelessWidget {
  const PolaroidPhoto({
    super.key,
    required this.image,
    required this.size,
    this.caption,
    this.angleDegrees = 0,
  });

  final String image;
  final double size;
  final String? caption;
  final double angleDegrees;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angleDegrees * 3.141592653589793 / 180,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.16),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImage(image, width: size, height: size),
            SizedBox(
              height: caption == null ? 14 : 26,
              child: caption == null
                  ? null
                  : Center(child: Text(caption!, style: AppTextStyles.hand(size: 18))),
            ),
          ],
        ),
      ),
    );
  }
}
