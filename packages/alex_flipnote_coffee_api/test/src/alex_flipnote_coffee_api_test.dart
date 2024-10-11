import 'dart:typed_data';

import 'package:alex_flipnote_coffee_api/alex_flipnote_coffee_api.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('AlexFlipnoteCoffeeApiClient', () {
    late http.Client httpClient;
    late AlexFlipnoteCoffeeApiClient apiClient;

    setUp(() {
      httpClient = MockHttpClient();
      apiClient = AlexFlipnoteCoffeeApiClient(httpClient: httpClient);
    });

    group('constructor', () {
      test('does not require an httpClient', () {
        expect(AlexFlipnoteCoffeeApiClient(), isNotNull);
      });
    });

    group('fetchRandomImage', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.bodyBytes).thenReturn(Uint8List.fromList([]));
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        try {
          await apiClient.fetchRandomImage();
        } catch (_) {}
        verify(
          () => httpClient.get(
            Uri.https(
              'coffee.alexflipnote.dev',
              '/random.json',
            ),
          ),
        ).called(1);
      });

      test('throws ImageRequestFailure on non-200 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          () async => apiClient.fetchRandomImage(),
          throwsA(isA<ImageRequestFailure>()),
        );
      });

      test('throws ImageRequestFailure on Exception', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.bodyBytes)
            .thenThrow(Exception('Something went wrong'));
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          () async => apiClient.fetchRandomImage(),
          throwsA(isA<ImageRequestFailure>()),
        );
      });

      test('returns Image on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '{"file": "https://coffee.alexflipnote.dev/1234.jpeg"}',
        );
        when(() => response.bodyBytes)
            .thenReturn(Uint8List.fromList([1, 2, 3]));
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        final actual = await apiClient.fetchRandomImage();
        expect(
          actual,
          isA<Image>().having((i) => i.bytes, 'bytes', [1, 2, 3]).having(
            (i) => i.filename,
            'filename',
            '1234.jpeg',
          ),
        );
      });
    });
  });
}
