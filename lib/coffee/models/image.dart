import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class Image extends Equatable {
  const Image({
    required this.isFavorite,
    required this.imageType,
    required this.bytes,
  });

  final bool isFavorite;
  final String imageType;
  final Uint8List bytes;

  Image copyWith({
    bool? isFavorite,
    String? imageType,
    Uint8List? bytes,
  }) {
    return Image(
      isFavorite: isFavorite ?? this.isFavorite,
      imageType: imageType ?? this.imageType,
      bytes: bytes ?? this.bytes,
    );
  }

  @override
  List<Object?> get props => [isFavorite, imageType, bytes];

  @override
  String toString() {
    return 'Image(isFavorite: $isFavorite, imageType: $imageType, '
        'bytesLength: ${bytes.length})';
  }
}
