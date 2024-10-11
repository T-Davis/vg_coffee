import 'dart:typed_data';

/// {@template coffee_image}
/// Represents a coffee image.
/// {@endtemplate}
class CoffeeImage {
  /// {@macro coffee_image}
  const CoffeeImage({
    required this.filename,
    required this.bytes,
  });

  /// The file name, for example `image.png`.
  final String filename;

  /// The raw bytes of the image data.
  final Uint8List bytes;
}
