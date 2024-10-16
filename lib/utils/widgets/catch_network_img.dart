import 'package:flutter/material.dart';

class CatchNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const CatchNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      // Placeholder while the image is loading
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child; // Image loaded successfully
        } else {
          return SizedBox(
            width: width,
            height: height,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            ),
          );
        }
      },
      // Error handling
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Placeholder(
          fallbackHeight: height!,
          fallbackWidth: width!,
        );
      },
    );
  }
}
