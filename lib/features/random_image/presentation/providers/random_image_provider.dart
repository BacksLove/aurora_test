import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/errors/result.dart';
import '../../data/models/image_response.dart';

part 'random_image_provider.g.dart';

@riverpod
class RandomImage extends _$RandomImage {
  @override
  FutureOr<ImageResponse> build() {
    return _fetchImage();
  }

  Future<ImageResponse> _fetchImage() async {
    final useCase = ref.read(getRandomImageUseCaseProvider);
    final result = await useCase();

    return switch (result) {
      Success(value: final imageResponse) => imageResponse,
      // Throw the typed Failure to preserve error type information
      // UI can pattern match on Failure type for specific error handling
      Error(failure: final failure) => throw failure,
    };
  }

  Future<void> fetchNewImage() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchImage());
  }
}
