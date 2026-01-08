import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_engineer_assignment/features/random_image/data/models/image_response.dart';
import 'package:mobile_engineer_assignment/features/random_image/data/repositories/image_repository_impl.dart';
import 'package:mobile_engineer_assignment/features/random_image/presentation/providers/random_image_provider.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile_engineer_assignment/features/random_image/domain/repositories/image_repository.dart';

class MockImageRepository extends Mock implements ImageRepository {}

void main() {
  late MockImageRepository mockRepository;

  setUp(() {
    mockRepository = MockImageRepository();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [imageRepositoryProvider.overrideWithValue(mockRepository)],
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
      () => mockRepository.getRandomImage(),
    ).thenAnswer((_) async => tImageResponse);

    final container = createContainer();

    // Wait for the provider to initialize
    await container.read(randomImageProvider.future);

    expect(
      container.read(randomImageProvider),
      const AsyncValue.data(tImageResponse),
    );
  });

  test('build returns error state when repository throws exception', () async {
    final exception = Exception('Network error');
    when(() => mockRepository.getRandomImage()).thenThrow(exception);

    final container = ProviderContainer(
      overrides: [imageRepositoryProvider.overrideWithValue(mockRepository)],
    );

    // Listen to the provider to keep it alive
    final listener = container.listen(randomImageProvider, (previous, next) {});

    // Wait for the error to be caught
    await Future.delayed(const Duration(milliseconds: 100));

    final state = container.read(randomImageProvider);
    expect(state.hasError, true);
    expect(state.error, exception);

    listener.close();
    container.dispose();
  });

  test('fetchNewImage updates state to loading then data on success', () async {
    const tImageResponse = ImageResponse(url: 'https://example.com/image.jpg');
    const tImageResponse2 = ImageResponse(
      url: 'https://example.com/image2.jpg',
    );

    when(
      () => mockRepository.getRandomImage(),
    ).thenAnswer((_) async => tImageResponse);

    final container = createContainer();

    // Wait for initial load
    await container.read(randomImageProvider.future);

    // Update mock for second call
    when(
      () => mockRepository.getRandomImage(),
    ).thenAnswer((_) async => tImageResponse2);

    // Trigger fetch
    await container.read(randomImageProvider.notifier).fetchNewImage();

    expect(
      container.read(randomImageProvider),
      const AsyncValue.data(tImageResponse2),
    );
    verify(() => mockRepository.getRandomImage()).called(2);
  });

  test('fetchNewImage updates state to error on failure', () async {
    const tImageResponse = ImageResponse(url: 'https://example.com/image.jpg');
    final exception = Exception('Network error');

    // First call succeeds
    when(
      () => mockRepository.getRandomImage(),
    ).thenAnswer((_) async => tImageResponse);

    final container = createContainer();

    // Wait for initial load
    await container.read(randomImageProvider.future);

    // Make second call fail
    when(() => mockRepository.getRandomImage()).thenThrow(exception);

    // Trigger fetch that will fail
    await container.read(randomImageProvider.notifier).fetchNewImage();

    expect(container.read(randomImageProvider).hasError, true);
  });

  test('handles timeout error correctly', () async {
    final exception = Exception('Connection timeout');
    when(() => mockRepository.getRandomImage()).thenThrow(exception);

    final container = ProviderContainer(
      overrides: [imageRepositoryProvider.overrideWithValue(mockRepository)],
    );

    // Listen to the provider to keep it alive
    final listener = container.listen(randomImageProvider, (previous, next) {});

    // Wait for the error to be caught
    await Future.delayed(const Duration(milliseconds: 100));

    // Check state after the error has been caught
    final state = container.read(randomImageProvider);
    expect(state.hasError, true);
    expect(state.error, exception);

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
      () => mockRepository.getRandomImage(),
    ).thenAnswer((_) async => tImageResponse1);

    final container = createContainer();

    // First load
    await container.read(randomImageProvider.future);
    expect(container.read(randomImageProvider).value, tImageResponse1);

    // Second fetch
    when(
      () => mockRepository.getRandomImage(),
    ).thenAnswer((_) async => tImageResponse2);
    await container.read(randomImageProvider.notifier).fetchNewImage();
    expect(container.read(randomImageProvider).value, tImageResponse2);

    // Third fetch
    when(
      () => mockRepository.getRandomImage(),
    ).thenAnswer((_) async => tImageResponse3);
    await container.read(randomImageProvider.notifier).fetchNewImage();
    expect(container.read(randomImageProvider).value, tImageResponse3);

    verify(() => mockRepository.getRandomImage()).called(3);
  });
}
