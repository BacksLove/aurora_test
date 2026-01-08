import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_engineer_assignment/core/di/providers.dart';
import 'package:mobile_engineer_assignment/core/errors/result.dart';
import 'package:mobile_engineer_assignment/features/random_image/data/models/image_response.dart';
import 'package:mobile_engineer_assignment/features/random_image/domain/usecases/get_random_image_usecase.dart';
import 'package:mobile_engineer_assignment/features/random_image/presentation/providers/random_image_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockGetRandomImageUseCase extends Mock implements GetRandomImageUseCase {}

void main() {
  late MockGetRandomImageUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetRandomImageUseCase();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [getRandomImageUseCaseProvider.overrideWithValue(mockUseCase)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('initial state is loading', () {
    final container = createContainer();
    expect(
      container.read(randomImageProvider),
      const AsyncValue<ImageResponse>.loading(),
    );
  });

  test('build returns ImageResponse on success', () async {
    const tImageResponse = ImageResponse(url: 'https://example.com/image.jpg');
    when(
      () => mockUseCase(),
    ).thenAnswer((_) async => const Success(tImageResponse));

    final container = createContainer();

    // Wait for the provider to initialize
    await container.read(randomImageProvider.future);

    expect(
      container.read(randomImageProvider),
      const AsyncValue.data(tImageResponse),
    );
  });

  test('build returns error state when repository returns Error', () async {
    when(
      () => mockUseCase(),
    ).thenAnswer((_) async => Error(Exception('Network error') as Never));

    final container = ProviderContainer(
      overrides: [getRandomImageUseCaseProvider.overrideWithValue(mockUseCase)],
    );

    // Listen to the provider to keep it alive
    final listener = container.listen(randomImageProvider, (previous, next) {});

    // Wait for the error to be caught
    await Future.delayed(const Duration(milliseconds: 100));

    final state = container.read(randomImageProvider);
    expect(state.hasError, true);

    listener.close();
    container.dispose();
  });

  test('fetchNewImage updates state to loading then data on success', () async {
    const tImageResponse = ImageResponse(url: 'https://example.com/image.jpg');
    const tImageResponse2 = ImageResponse(
      url: 'https://example.com/image2.jpg',
    );

    when(
      () => mockUseCase(),
    ).thenAnswer((_) async => const Success(tImageResponse));

    final container = createContainer();

    // Wait for initial load
    await container.read(randomImageProvider.future);

    // Update mock for second call
    when(
      () => mockUseCase(),
    ).thenAnswer((_) async => const Success(tImageResponse2));

    // Trigger fetch
    await container.read(randomImageProvider.notifier).fetchNewImage();

    expect(
      container.read(randomImageProvider),
      const AsyncValue.data(tImageResponse2),
    );
    verify(() => mockUseCase()).called(2);
  });

  test('fetchNewImage updates state to error on failure', () async {
    const tImageResponse = ImageResponse(url: 'https://example.com/image.jpg');

    // First call succeeds
    when(
      () => mockUseCase(),
    ).thenAnswer((_) async => const Success(tImageResponse));

    final container = createContainer();

    // Wait for initial load
    await container.read(randomImageProvider.future);

    // Make second call fail with Error result
    when(
      () => mockUseCase(),
    ).thenAnswer((_) async => Error(Exception('Network error') as Never));

    // Trigger fetch that will fail
    await container.read(randomImageProvider.notifier).fetchNewImage();

    expect(container.read(randomImageProvider).hasError, true);
  });

  test('handles timeout error correctly', () async {
    when(
      () => mockUseCase(),
    ).thenAnswer((_) async => Error(Exception('Connection timeout') as Never));

    final container = ProviderContainer(
      overrides: [getRandomImageUseCaseProvider.overrideWithValue(mockUseCase)],
    );

    // Listen to the provider to keep it alive
    final listener = container.listen(randomImageProvider, (previous, next) {});

    // Wait for the error to be caught
    await Future.delayed(const Duration(milliseconds: 100));

    // Check state after the error has been caught
    final state = container.read(randomImageProvider);
    expect(state.hasError, true);

    listener.close();
    container.dispose();
  });

  test('handles multiple consecutive fetch new image calls', () async {
    const tImageResponse1 = ImageResponse(
      url: 'https://example.com/image1.jpg',
    );
    const tImageResponse2 = ImageResponse(
      url: 'https://example.com/image2.jpg',
    );
    const tImageResponse3 = ImageResponse(
      url: 'https://example.com/image3.jpg',
    );

    when(
      () => mockUseCase(),
    ).thenAnswer((_) async => const Success(tImageResponse1));

    final container = createContainer();

    // First load
    await container.read(randomImageProvider.future);
    expect(container.read(randomImageProvider).value, tImageResponse1);

    // Second fetch
    when(
      () => mockUseCase(),
    ).thenAnswer((_) async => const Success(tImageResponse2));
    await container.read(randomImageProvider.notifier).fetchNewImage();
    expect(container.read(randomImageProvider).value, tImageResponse2);

    // Third fetch
    when(
      () => mockUseCase(),
    ).thenAnswer((_) async => const Success(tImageResponse3));
    await container.read(randomImageProvider.notifier).fetchNewImage();
    expect(container.read(randomImageProvider).value, tImageResponse3);

    verify(() => mockUseCase()).called(3);
  });
}
