import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/image_response.dart';
import '../../data/repositories/image_repository_impl.dart';

part 'random_image_provider.g.dart';

@riverpod
class RandomImage extends _$RandomImage {
  @override
  FutureOr<ImageResponse> build() {
    return _fetchImage();
  }

  Future<ImageResponse> _fetchImage() async {
    final repository = ref.read(imageRepositoryProvider);
    return repository.getRandomImage();
  }

  Future<void> fetchNewImage() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchImage());
  }
}
