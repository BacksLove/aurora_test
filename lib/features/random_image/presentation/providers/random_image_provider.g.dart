// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'random_image_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RandomImage)
final randomImageProvider = RandomImageProvider._();

final class RandomImageProvider
    extends $AsyncNotifierProvider<RandomImage, ImageResponse> {
  RandomImageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'randomImageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$randomImageHash();

  @$internal
  @override
  RandomImage create() => RandomImage();
}

String _$randomImageHash() => r'4bc8b5e71f964ed881d78c57cd4a2ae9613eb721';

abstract class _$RandomImage extends $AsyncNotifier<ImageResponse> {
  FutureOr<ImageResponse> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ImageResponse>, ImageResponse>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ImageResponse>, ImageResponse>,
              AsyncValue<ImageResponse>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
