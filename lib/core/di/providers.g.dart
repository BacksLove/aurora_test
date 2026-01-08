// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composition Root - Dependency Injection Configuration
///
/// This file serves as the composition root for the application,
/// wiring together all dependencies while respecting Clean Architecture boundaries.
/// Provides the ImageRepository implementation

@ProviderFor(imageRepository)
final imageRepositoryProvider = ImageRepositoryProvider._();

/// Composition Root - Dependency Injection Configuration
///
/// This file serves as the composition root for the application,
/// wiring together all dependencies while respecting Clean Architecture boundaries.
/// Provides the ImageRepository implementation

final class ImageRepositoryProvider
    extends
        $FunctionalProvider<ImageRepository, ImageRepository, ImageRepository>
    with $Provider<ImageRepository> {
  /// Composition Root - Dependency Injection Configuration
  ///
  /// This file serves as the composition root for the application,
  /// wiring together all dependencies while respecting Clean Architecture boundaries.
  /// Provides the ImageRepository implementation
  ImageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageRepositoryHash();

  @$internal
  @override
  $ProviderElement<ImageRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImageRepository create(Ref ref) {
    return imageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageRepository>(value),
    );
  }
}

String _$imageRepositoryHash() => r'1c666be1cf5363e503d8783367700e9ae163017c';

/// Provides the GetRandomImageUseCase
/// Only depends on the ImageRepository interface (domain layer)

@ProviderFor(getRandomImageUseCase)
final getRandomImageUseCaseProvider = GetRandomImageUseCaseProvider._();

/// Provides the GetRandomImageUseCase
/// Only depends on the ImageRepository interface (domain layer)

final class GetRandomImageUseCaseProvider
    extends
        $FunctionalProvider<
          GetRandomImageUseCase,
          GetRandomImageUseCase,
          GetRandomImageUseCase
        >
    with $Provider<GetRandomImageUseCase> {
  /// Provides the GetRandomImageUseCase
  /// Only depends on the ImageRepository interface (domain layer)
  GetRandomImageUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getRandomImageUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getRandomImageUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetRandomImageUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetRandomImageUseCase create(Ref ref) {
    return getRandomImageUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetRandomImageUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetRandomImageUseCase>(value),
    );
  }
}

String _$getRandomImageUseCaseHash() =>
    r'e9d0b5b7bc523557e8a885ca37859b975f1f0d32';
