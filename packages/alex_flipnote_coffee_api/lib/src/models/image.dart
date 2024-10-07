import 'dart:typed_data';

/// {@template image}
/// Represents an image retrieved from the API.
/// {@endtemplate}
class Image {
  /// {@macro image}
  const Image({
    required this.imageType,
    required this.bytes,
  });

  /// The type of the image.
  final String imageType;

  /// The raw bytes of the image data.
  final Uint8List bytes;
}
