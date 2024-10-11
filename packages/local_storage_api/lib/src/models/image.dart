import 'dart:typed_data';

/// {@template image}
/// Represents an image.
/// {@endtemplate}
class Image {
  /// {@macro coffee_image}
  const Image({
    required this.filename,
    required this.bytes,
  });

  /// The file name, for example `image.png`.
  final String filename;

  /// The raw bytes of the image data.
  final Uint8List bytes;
}
