import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class Image extends Equatable {
  const Image({
    required this.filename,
    required this.bytes,
  });

  final String filename;
  final Uint8List bytes;

  Image copyWith({
    String? filename,
    Uint8List? bytes,
  }) {
    return Image(
      filename: filename ?? this.filename,
      bytes: bytes ?? this.bytes,
    );
  }

  @override
  List<Object?> get props => [filename, bytes];

  @override
  String toString() {
    return 'Image(filename: $filename, bytesLength: ${bytes.length})';
  }
}
