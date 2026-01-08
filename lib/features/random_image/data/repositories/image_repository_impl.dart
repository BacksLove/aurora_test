import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_provider.dart';
import '../../domain/repositories/image_repository.dart';
import '../models/image_response.dart';

part 'image_repository_impl.g.dart';

class ImageRepositoryImpl implements ImageRepository {
  final Dio _dio;

  ImageRepositoryImpl(this._dio);

  @override
  Future<ImageResponse> getRandomImage() async {
    try {
      final response = await _dio.get('/image');
      return ImageResponse.fromJson(response.data);
    } catch (e) {
      // In a real app, we would map DioError to a Domain Failure
      rethrow;
    }
  }
}

@riverpod
ImageRepository imageRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ImageRepositoryImpl(dio);
}
