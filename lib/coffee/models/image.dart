import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class Image extends Equatable {
  const Image({
    required this.isFavorite,
    required this.filename,
    required this.bytes,
  });

  final bool isFavorite;
  final String filename;
  final Uint8List bytes;

  Image copyWith({
    bool? isFavorite,
    String? filename,
    Uint8List? bytes,
  }) {
    return Image(
      isFavorite: isFavorite ?? this.isFavorite,
      filename: filename ?? this.filename,
      bytes: bytes ?? this.bytes,
    );
  }

  @override
  List<Object?> get props => [isFavorite, filename, bytes];

  @override
  String toString() {
    return 'Image(isFavorite: $isFavorite, filename: $filename, '
        'bytesLength: ${bytes.length})';
  }
}
