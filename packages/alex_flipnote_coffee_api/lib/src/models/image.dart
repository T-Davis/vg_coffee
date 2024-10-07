import 'dart:typed_data';

/// {@template image}
/// Represents an image retrieved from the API.
/// {@endtemplate}
class Image {
  /// {@macro image}
  const Image({
    required this.contentType,
    required this.bytes,
  });

  /// The content type of the image.
  final String contentType;

  /// The raw bytes of the image data.
  final Uint8List bytes;
}
