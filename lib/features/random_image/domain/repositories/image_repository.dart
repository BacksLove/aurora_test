import '../../../../core/errors/result.dart';
import '../../data/models/image_response.dart';

abstract class ImageRepository {
  Future<Result<ImageResponse>> getRandomImage();
}
