import 'dart:async';

import 'package:alex_flipnote_coffee_api/alex_flipnote_coffee_api.dart';
import 'package:alex_flipnote_coffee_api/src/models/image.dart';
import 'package:alex_flipnote_coffee_api/src/models/models.dart';
import 'package:http/http.dart' as http;

/// Exception thrown when fetchRandomImage fails.
class ImageRequestFailure implements Exception {}

/// {@template alex_flipnote_coffee_api_client}
/// Dart API Client which wraps the [Alex Flipnote Coffee API](https://coffee.alexflipnote.dev/).
/// {@endtemplate}
class AlexFlipnoteCoffeeApiClient {
  /// {@macro alex_flipnote_coffee_api_client}
  AlexFlipnoteCoffeeApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'coffee.alexflipnote.dev';

  final http.Client _httpClient;

  /// Fetches a random [Image] `/random`.
  Future<Image> fetchRandomImage() async {
    try {
      final request = Uri.https(_baseUrl, '/random');

      final response = await _httpClient.get(request);

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        if (contentType == null || !contentType.startsWith('image/')) {
          throw ImageRequestFailure();
        }
        final imageType = contentType.replaceFirst('image/', '');
        final bytes = response.bodyBytes;
        final image = Image(imageType: imageType, bytes: bytes);
        return image;
      } else {
        throw ImageRequestFailure();
      }
    } catch (e) {
      throw ImageRequestFailure();
    }
  }
}
