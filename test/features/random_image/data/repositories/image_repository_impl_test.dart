import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_engineer_assignment/features/random_image/data/models/image_response.dart';
import 'package:mobile_engineer_assignment/features/random_image/data/repositories/image_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ImageRepositoryImpl repository;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    repository = ImageRepositoryImpl(mockDio);
  });

  group('ImageRepositoryImpl', () {
    const tImageResponse = ImageResponse(url: 'https://example.com/image.jpg');
    final tResponseData = {'url': 'https://example.com/image.jpg'};

    test(
      'should return ImageResponse when the call to remote data source is successful',
      () async {
        // Arrange
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: tResponseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/image'),
          ),
        );

        // Act
        final result = await repository.getRandomImage();

        // Assert
        expect(result, tImageResponse);
        verify(() => mockDio.get('/image')).called(1);
      },
    );

    test(
      'should throw an exception when the call to remote data source is unsuccessful',
      () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(requestOptions: RequestOptions(path: '/image')),
        );

        // Act
        final call = repository.getRandomImage;

        // Assert
        expect(() => call(), throwsA(isA<DioException>()));
      },
    );
  });
}
