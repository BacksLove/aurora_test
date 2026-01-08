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
      overrides: [
        imageRepositoryProvider.overrideWithValue(mockRepository),
      ],
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
    when(() => mockRepository.getRandomImage()).thenAnswer((_) async => tImageResponse);

    final container = createContainer();

    // Wait for the provider to initialize
    await container.read(randomImageProvider.future);

    expect(
      container.read(randomImageProvider),
      const AsyncValue.data(tImageResponse),
    );
  });
}
