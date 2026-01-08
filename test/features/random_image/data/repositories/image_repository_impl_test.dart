import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_engineer_assignment/core/errors/failures.dart';
import 'package:mobile_engineer_assignment/core/errors/result.dart';
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
      'should return Success with ImageResponse when the call to remote data source is successful',
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
        expect(result, isA<Success<ImageResponse>>());
        expect((result as Success<ImageResponse>).value, tImageResponse);
        verify(() => mockDio.get('/image')).called(1);
      },
    );

    test(
      'should return Error with NetworkFailure when the call has connection error',
      () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/image'),
            type: DioExceptionType.connectionError,
            error: 'Network error',
          ),
        );

        // Act
        final result = await repository.getRandomImage();

        // Assert
        expect(result, isA<Error<ImageResponse>>());
        expect((result as Error<ImageResponse>).failure, isA<NetworkFailure>());
      },
    );

    test(
      'should return Error with TimeoutFailure on connection timeout',
      () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/image'),
            type: DioExceptionType.connectionTimeout,
            error: 'Connection timeout',
          ),
        );

        // Act
        final result = await repository.getRandomImage();

        // Assert
        expect(result, isA<Error<ImageResponse>>());
        expect((result as Error<ImageResponse>).failure, isA<TimeoutFailure>());
      },
    );

    test(
      'should return Error with TimeoutFailure on receive timeout',
      () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/image'),
            type: DioExceptionType.receiveTimeout,
            error: 'Receive timeout',
          ),
        );

        // Act
        final result = await repository.getRandomImage();

        // Assert
        expect(result, isA<Error<ImageResponse>>());
        expect((result as Error<ImageResponse>).failure, isA<TimeoutFailure>());
      },
    );

    test(
      'should return Error with UnexpectedFailure on invalid response data (missing url)',
      () async {
        // Arrange
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: {'invalid': 'data'},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/image'),
          ),
        );

        // Act
        final result = await repository.getRandomImage();

        // Assert
        expect(result, isA<Error<ImageResponse>>());
        expect(
          (result as Error<ImageResponse>).failure,
          isA<UnexpectedFailure>(),
        );
      },
    );

    test(
      'should return Error with UnexpectedFailure on null response data',
      () async {
        // Arrange
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/image'),
          ),
        );

        // Act
        final result = await repository.getRandomImage();

        // Assert
        expect(result, isA<Error<ImageResponse>>());
        expect(
          (result as Error<ImageResponse>).failure,
          isA<UnexpectedFailure>(),
        );
      },
    );

    test('should return Error with ServerFailure on 404 error', () async {
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

      // Act
      final result = await repository.getRandomImage();

      // Assert
      expect(result, isA<Error<ImageResponse>>());
      final failure = (result as Error<ImageResponse>).failure;
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 404);
    });

    test(
      'should return Error with ServerFailure on 500 server error',
      () async {
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

        // Act
        final result = await repository.getRandomImage();

        // Assert
        expect(result, isA<Error<ImageResponse>>());
        final failure = (result as Error<ImageResponse>).failure;
        expect(failure, isA<ServerFailure>());
        expect((failure as ServerFailure).statusCode, 500);
      },
    );

    test(
      'should return Error with CancelledFailure on cancel request',
      () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/image'),
            type: DioExceptionType.cancel,
            error: 'Request cancelled',
          ),
        );

        // Act
        final result = await repository.getRandomImage();

        // Assert
        expect(result, isA<Error<ImageResponse>>());
        expect(
          (result as Error<ImageResponse>).failure,
          isA<CancelledFailure>(),
        );
      },
    );

    test('should return Error with TimeoutFailure on send timeout', () async {
      // Arrange
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/image'),
          type: DioExceptionType.sendTimeout,
          error: 'Send timeout',
        ),
      );

      // Act
      final result = await repository.getRandomImage();

      // Assert
      expect(result, isA<Error<ImageResponse>>());
      expect((result as Error<ImageResponse>).failure, isA<TimeoutFailure>());
    });
  });
}
