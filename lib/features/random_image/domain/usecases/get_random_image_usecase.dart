import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../data/models/image_response.dart';
import '../../data/repositories/image_repository_impl.dart';
import '../repositories/image_repository.dart';

part 'get_random_image_usecase.g.dart';

/// UseCase for fetching a random image
///
/// Encapsulates business rules:
/// - Validates image URL before returning
/// - Could add caching logic
/// - Could add rate limiting
/// - Could add image format validation
class GetRandomImageUseCase {
  final ImageRepository _repository;

  GetRandomImageUseCase(this._repository);

  /// Executes the use case to fetch a random image
  ///
  /// Business rules applied:
  /// 1. Fetch image from repository
  /// 2. Validate that URL is not empty
  /// 3. Validate that URL is a valid HTTP/HTTPS URL
  Future<Result<ImageResponse>> call() async {
    final result = await _repository.getRandomImage();

    // Apply business validation on success
    return switch (result) {
      Success(value: final imageResponse) => _validateImageResponse(
        imageResponse,
      ),
      Error(failure: final failure) => Error(failure),
    };
  }

  /// Validates the image response according to business rules
  Result<ImageResponse> _validateImageResponse(ImageResponse response) {
    // Business Rule 1: URL must not be empty
    if (response.url.isEmpty) {
      return const Error(UnexpectedFailure('Image URL cannot be empty'));
    }

    // Business Rule 2: URL must be a valid HTTP/HTTPS URL
    final uri = Uri.tryParse(response.url);
    if (uri == null ||
        (!uri.hasScheme || (uri.scheme != 'http' && uri.scheme != 'https'))) {
      return Error(UnexpectedFailure('Invalid image URL: ${response.url}'));
    }

    // Business Rule 3: URL must have a host
    if (!uri.hasAuthority || uri.host.isEmpty) {
      return Error(
        UnexpectedFailure('Image URL must have a valid host: ${response.url}'),
      );
    }

    // All business rules passed
    return Success(response);
  }
}

@riverpod
GetRandomImageUseCase getRandomImageUseCase(Ref ref) {
  final repository = ref.watch(imageRepositoryProvider);
  return GetRandomImageUseCase(repository);
}
