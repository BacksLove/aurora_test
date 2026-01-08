import '../../data/models/image_response.dart';

abstract class ImageRepository {
  Future<ImageResponse> getRandomImage();
}
