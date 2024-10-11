import 'package:alex_flipnote_coffee_api/alex_flipnote_coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';

/// {@template coffee_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class CoffeeRepository {
  /// {@macro coffee_repository}
  CoffeeRepository({AlexFlipnoteCoffeeApiClient? coffeeApiClient})
      : _coffeeApiClient = coffeeApiClient ?? AlexFlipnoteCoffeeApiClient();

  final AlexFlipnoteCoffeeApiClient _coffeeApiClient;

  /// Returns a [CoffeeImage] fetched from the network.
  Future<CoffeeImage> fetchCoffeeImage() async {
    final image = await _coffeeApiClient.fetchRandomImage();
    return CoffeeImage(
      filename: image.filename,
      bytes: image.bytes,
    );
  }
}
