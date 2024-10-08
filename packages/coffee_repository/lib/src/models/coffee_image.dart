import 'dart:typed_data';

/// {@template coffee_image}
/// Represents a coffee image.
/// {@endtemplate}
class CoffeeImage {
  /// {@macro coffee_image}
  const CoffeeImage({
    required this.imageType,
    required this.bytes,
  });

  /// The image type, for example `png`.
  final String imageType;

  /// The raw bytes of the image data.
  final Uint8List bytes;
}
