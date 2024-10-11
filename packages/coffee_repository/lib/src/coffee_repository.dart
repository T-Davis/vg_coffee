import 'dart:typed_data';

import 'package:alex_flipnote_coffee_api/alex_flipnote_coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:local_storage_api/local_storage_api.dart';

/// {@template coffee_repository}
/// Dart repository for managing coffee data.
/// {@endtemplate}
class CoffeeRepository {
  /// {@macro coffee_repository}
  CoffeeRepository({
    AlexFlipnoteCoffeeApiClient? coffeeApiClient,
    LocalStorageApi? localStorageApi,
  })  : _coffeeApiClient = coffeeApiClient ?? AlexFlipnoteCoffeeApiClient(),
        _localStorageApi = localStorageApi ?? LocalStorageApi();

  final AlexFlipnoteCoffeeApiClient _coffeeApiClient;
  final LocalStorageApi _localStorageApi;

  /// Returns a [CoffeeImage] fetched from the network.
  Future<CoffeeImage> fetchCoffeeImage() async {
    final image = await _coffeeApiClient.fetchRandomImage();
    return CoffeeImage(
      filename: image.filename,
      bytes: image.bytes,
    );
  }

  /// Saves a [CoffeeImage] to local storage.
  Future<void> saveCoffeeImage({
    required Uint8List bytes,
    required String filename,
  }) async {
    await _localStorageApi.saveImage(
      bytes: bytes,
      filename: filename,
    );
  }

  /// Deletes a [CoffeeImage] from local storage.
  Future<void> deleteCoffeeImage(String filename) async {
    await _localStorageApi.deleteImage(filename);
  }

  /// Retrieves all [CoffeeImage]s from local storage.
  Future<List<CoffeeImage>> getCoffeeImages() async {
    final images = await _localStorageApi.getImages();
    return images.map((image) {
      return CoffeeImage(
        filename: image.filename,
        bytes: image.bytes,
      );
    }).toList();
  }
}
