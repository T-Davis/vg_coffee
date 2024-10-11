import 'dart:typed_data';

/// {@template image}
/// Represents an image retrieved from the API.
/// {@endtemplate}
class Image {
  /// {@macro image}
  const Image({
    required this.filename,
    required this.bytes,
  });

  /// The name of the image.
  final String filename;

  /// The raw bytes of the image data.
  final Uint8List bytes;
}
