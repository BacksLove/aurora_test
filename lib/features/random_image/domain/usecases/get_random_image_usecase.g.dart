// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_random_image_usecase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getRandomImageUseCase)
final getRandomImageUseCaseProvider = GetRandomImageUseCaseProvider._();

final class GetRandomImageUseCaseProvider
    extends
        $FunctionalProvider<
          GetRandomImageUseCase,
          GetRandomImageUseCase,
          GetRandomImageUseCase
        >
    with $Provider<GetRandomImageUseCase> {
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
