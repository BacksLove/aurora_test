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

    test('should throw DioException on network error', () async {
      // Arrange
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/image'),
          type: DioExceptionType.connectionError,
          error: 'Network error',
        ),
      );

      // Act & Assert
      expect(
        () => repository.getRandomImage(),
        throwsA(
          isA<DioException>().having(
            (e) => e.type,
            'type',
            DioExceptionType.connectionError,
          ),
        ),
      );
    });

    test('should throw DioException on connection timeout', () async {
      // Arrange
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/image'),
          type: DioExceptionType.connectionTimeout,
          error: 'Connection timeout',
        ),
      );

      // Act & Assert
      expect(
        () => repository.getRandomImage(),
        throwsA(
          isA<DioException>().having(
            (e) => e.type,
            'type',
            DioExceptionType.connectionTimeout,
          ),
        ),
      );
    });

    test('should throw DioException on receive timeout', () async {
      // Arrange
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/image'),
          type: DioExceptionType.receiveTimeout,
          error: 'Receive timeout',
        ),
      );

      // Act & Assert
      expect(
        () => repository.getRandomImage(),
        throwsA(
          isA<DioException>().having(
            (e) => e.type,
            'type',
            DioExceptionType.receiveTimeout,
          ),
        ),
      );
    });

    test(
      'should throw exception on invalid response data (missing url)',
      () async {
        // Arrange
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {'invalid': 'data'},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/image'),
          ),
        );

        // Act & Assert
        expect(() => repository.getRandomImage(), throwsA(isA<TypeError>()));
      },
    );

    test('should throw exception on null response data', () async {
      // Arrange
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/image'),
        ),
      );

      // Act & Assert
      expect(() => repository.getRandomImage(), throwsA(isA<TypeError>()));
    });

    test('should throw DioException on 404 error', () async {
      // Arrange
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/image'),
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/image'),
          ),
        ),
      );

      // Act & Assert
      expect(
        () => repository.getRandomImage(),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            404,
          ),
        ),
      );
    });

    test('should throw DioException on 500 server error', () async {
      // Arrange
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/image'),
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/image'),
          ),
        ),
      );

      // Act & Assert
      expect(
        () => repository.getRandomImage(),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            500,
          ),
        ),
      );
    });

    test('should throw DioException on cancel request', () async {
      // Arrange
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/image'),
          type: DioExceptionType.cancel,
          error: 'Request cancelled',
        ),
      );

      // Act & Assert
      expect(
        () => repository.getRandomImage(),
        throwsA(
          isA<DioException>().having(
            (e) => e.type,
            'type',
            DioExceptionType.cancel,
          ),
        ),
      );
    });
  });
}
