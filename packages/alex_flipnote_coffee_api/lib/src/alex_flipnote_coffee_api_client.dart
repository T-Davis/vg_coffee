import 'dart:async';
import 'dart:convert';

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

  /// Fetches a random coffee image.
  ///
  /// Returns an [Image] object.
  Future<Image> fetchRandomImage() async {
    final String fileUrl;
    final String filename;
    try {
      // Request a random file url.
      final jsonRequest = Uri.https(_baseUrl, '/random.json');
      final jsonResponse = await _httpClient.get(jsonRequest);

      /*
          Sample response:
          {
          "file": "https://coffee.alexflipnote.dev/O7w9wwX0Ym0_coffee.png"
          }
        */

      if (jsonResponse.statusCode == 200) {
        final jsonData = jsonDecode(jsonResponse.body) as Map<String, dynamic>;
        fileUrl = jsonData['file'] as String;
      } else {
        throw Exception();
      }

      // Request image from file url.
      final request = Uri.parse(fileUrl);
      final response = await _httpClient.get(request);

      if (response.statusCode == 200) {
        filename = Uri.parse(fileUrl).pathSegments.last;
        final bytes = response.bodyBytes;
        final image = Image(filename: filename, bytes: bytes);

        return image;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw ImageRequestFailure();
    }
  }
}
