import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/errors/result.dart';
import '../../data/models/image_response.dart';
import '../../domain/usecases/get_random_image_usecase.dart';

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
      Error(failure: final failure) => throw Exception(failure.message),
    };
  }

  Future<void> fetchNewImage() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchImage());
  }
}
