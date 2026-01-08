import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/dio_provider.dart';
import '../../domain/repositories/image_repository.dart';
import '../models/image_response.dart';

part 'image_repository_impl.g.dart';

class ImageRepositoryImpl implements ImageRepository {
  final Dio _dio;

  ImageRepositoryImpl(this._dio);

  @override
  Future<Result<ImageResponse>> getRandomImage() async {
    try {
      final response = await _dio.get('/image');

      // Validate response data
      if (response.data == null) {
        return const Error(UnexpectedFailure('Response data is null'));
      }

      try {
        final imageResponse = ImageResponse.fromJson(response.data);
        return Success(imageResponse);
      } catch (e) {
        return Error(UnexpectedFailure('Failed to parse response', e));
      }
    } on DioException catch (e) {
      return Error(_mapDioExceptionToFailure(e));
    } catch (e) {
      return Error(UnexpectedFailure('An unexpected error occurred', e));
    }
  }

  Failure _mapDioExceptionToFailure(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          exception.message ?? 'Connection timeout',
          exception,
        );

      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode;
        final message = exception.response?.statusMessage ?? 'Server error';
        return ServerFailure(
          'Server error: $message',
          statusCode: statusCode,
          error: exception,
        );

      case DioExceptionType.cancel:
        return CancelledFailure('Request cancelled', exception);

      case DioExceptionType.connectionError:
        return NetworkFailure(
          exception.message ?? 'Network connection error',
          exception,
        );

      case DioExceptionType.badCertificate:
        return NetworkFailure('SSL certificate error', exception);

      case DioExceptionType.unknown:
      default:
        return UnexpectedFailure(
          exception.message ?? 'An unexpected error occurred',
          exception,
        );
    }
  }
}

@riverpod
ImageRepository imageRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ImageRepositoryImpl(dio);
}
