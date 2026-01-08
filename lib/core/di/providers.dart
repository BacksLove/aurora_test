import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/random_image/data/repositories/image_repository_impl.dart';
import '../../features/random_image/domain/repositories/image_repository.dart';
import '../../features/random_image/domain/usecases/get_random_image_usecase.dart';
import '../network/dio_provider.dart';

part 'providers.g.dart';

/// Composition Root - Dependency Injection Configuration
///
/// This file serves as the composition root for the application,
/// wiring together all dependencies while respecting Clean Architecture boundaries.

/// Provides the ImageRepository implementation
@riverpod
ImageRepository imageRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ImageRepositoryImpl(dio);
}

/// Provides the GetRandomImageUseCase
/// Only depends on the ImageRepository interface (domain layer)
@riverpod
GetRandomImageUseCase getRandomImageUseCase(Ref ref) {
  final repository = ref.watch(imageRepositoryProvider);
  return GetRandomImageUseCase(repository);
}
