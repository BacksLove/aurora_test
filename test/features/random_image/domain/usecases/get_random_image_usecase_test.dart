import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_engineer_assignment/core/errors/failures.dart';
import 'package:mobile_engineer_assignment/core/errors/result.dart';
import 'package:mobile_engineer_assignment/features/random_image/data/models/image_response.dart';
import 'package:mobile_engineer_assignment/features/random_image/domain/repositories/image_repository.dart';
import 'package:mobile_engineer_assignment/features/random_image/domain/usecases/get_random_image_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockImageRepository extends Mock implements ImageRepository {}

void main() {
  late GetRandomImageUseCase useCase;
  late MockImageRepository mockRepository;

  setUp(() {
    mockRepository = MockImageRepository();
    useCase = GetRandomImageUseCase(mockRepository);
  });

  group('GetRandomImageUseCase', () {
    const validImageResponse = ImageResponse(
      url: 'https://example.com/image.jpg',
    );

    test('should return Success when repository returns valid image', () async {
      // Arrange
      when(
        () => mockRepository.getRandomImage(),
      ).thenAnswer((_) async => const Success(validImageResponse));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Success<ImageResponse>>());
      expect((result as Success<ImageResponse>).value, validImageResponse);
      verify(() => mockRepository.getRandomImage()).called(1);
    });

    test('should return Error when repository returns Error', () async {
      // Arrange
      const failure = NetworkFailure('Network error');
      when(
        () => mockRepository.getRandomImage(),
      ).thenAnswer((_) async => const Error(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Error<ImageResponse>>());
      expect((result as Error<ImageResponse>).failure, failure);
    });

    group('Business Rule: Empty URL validation', () {
      test('should return Error when URL is empty', () async {
        // Arrange
        const emptyUrlResponse = ImageResponse(url: '');
        when(
          () => mockRepository.getRandomImage(),
        ).thenAnswer((_) async => const Success(emptyUrlResponse));

        // Act
        final result = await useCase();

        // Assert
        expect(result, isA<Error<ImageResponse>>());
        final failure = (result as Error<ImageResponse>).failure;
        expect(failure, isA<UnexpectedFailure>());
        expect(failure.message, 'Image URL cannot be empty');
      });
    });

    group('Business Rule: Valid HTTP/HTTPS URL validation', () {
      test('should return Error when URL scheme is not http/https', () async {
        // Arrange
        const ftpUrlResponse = ImageResponse(
          url: 'ftp://example.com/image.jpg',
        );
        when(
          () => mockRepository.getRandomImage(),
        ).thenAnswer((_) async => const Success(ftpUrlResponse));

        // Act
        final result = await useCase();

        // Assert
        expect(result, isA<Error<ImageResponse>>());
        final failure = (result as Error<ImageResponse>).failure;
        expect(failure, isA<UnexpectedFailure>());
        expect(failure.message, contains('Invalid image URL'));
      });

      test('should return Error when URL has no scheme', () async {
        // Arrange
        const noSchemeResponse = ImageResponse(url: 'example.com/image.jpg');
        when(
          () => mockRepository.getRandomImage(),
        ).thenAnswer((_) async => const Success(noSchemeResponse));

        // Act
        final result = await useCase();

        // Assert
        expect(result, isA<Error<ImageResponse>>());
        final failure = (result as Error<ImageResponse>).failure;
        expect(failure, isA<UnexpectedFailure>());
        expect(failure.message, contains('Invalid image URL'));
      });

      test('should accept http URL', () async {
        // Arrange
        const httpResponse = ImageResponse(url: 'http://example.com/image.jpg');
        when(
          () => mockRepository.getRandomImage(),
        ).thenAnswer((_) async => const Success(httpResponse));

        // Act
        final result = await useCase();

        // Assert
        expect(result, isA<Success<ImageResponse>>());
        expect((result as Success<ImageResponse>).value, httpResponse);
      });

      test('should accept https URL', () async {
        // Arrange
        const httpsResponse = ImageResponse(
          url: 'https://example.com/image.jpg',
        );
        when(
          () => mockRepository.getRandomImage(),
        ).thenAnswer((_) async => const Success(httpsResponse));

        // Act
        final result = await useCase();

        // Assert
        expect(result, isA<Success<ImageResponse>>());
        expect((result as Success<ImageResponse>).value, httpsResponse);
      });
    });

    group('Business Rule: Valid host validation', () {
      test('should return Error when URL has no host', () async {
        // Arrange
        const noHostResponse = ImageResponse(url: 'https:///image.jpg');
        when(
          () => mockRepository.getRandomImage(),
        ).thenAnswer((_) async => const Success(noHostResponse));

        // Act
        final result = await useCase();

        // Assert
        expect(result, isA<Error<ImageResponse>>());
        final failure = (result as Error<ImageResponse>).failure;
        expect(failure, isA<UnexpectedFailure>());
        expect(failure.message, contains('must have a valid host'));
      });

      test('should accept URL with valid host', () async {
        // Arrange
        const validHostResponse = ImageResponse(
          url: 'https://cdn.example.com/path/to/image.jpg',
        );
        when(
          () => mockRepository.getRandomImage(),
        ).thenAnswer((_) async => const Success(validHostResponse));

        // Act
        final result = await useCase();

        // Assert
        expect(result, isA<Success<ImageResponse>>());
        expect((result as Success<ImageResponse>).value, validHostResponse);
      });
    });

    group('Error propagation', () {
      test('should propagate NetworkFailure', () async {
        // Arrange
        const failure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.getRandomImage(),
        ).thenAnswer((_) async => const Error(failure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, isA<Error<ImageResponse>>());
        expect((result as Error<ImageResponse>).failure, isA<NetworkFailure>());
      });

      test('should propagate TimeoutFailure', () async {
        // Arrange
        const failure = TimeoutFailure('Connection timeout');
        when(
          () => mockRepository.getRandomImage(),
        ).thenAnswer((_) async => const Error(failure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, isA<Error<ImageResponse>>());
        expect((result as Error<ImageResponse>).failure, isA<TimeoutFailure>());
      });

      test('should propagate ServerFailure', () async {
        // Arrange
        const failure = ServerFailure('Internal server error', statusCode: 500);
        when(
          () => mockRepository.getRandomImage(),
        ).thenAnswer((_) async => const Error(failure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, isA<Error<ImageResponse>>());
        expect((result as Error<ImageResponse>).failure, isA<ServerFailure>());
      });
    });
  });
}
