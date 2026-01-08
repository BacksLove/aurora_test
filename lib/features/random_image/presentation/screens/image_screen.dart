import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import '../providers/random_image_provider.dart';
import 'image_screen_constants.dart';

class ImageScreen extends ConsumerStatefulWidget {
  const ImageScreen({super.key});

  @override
  ConsumerState<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends ConsumerState<ImageScreen> {
  Color? _backgroundColor;
  String? _lastProcessedUrl;
  double _imageOpacity = 0.0;

  String _buildOptimizedUrl(String url) {
    final uri = Uri.parse(url);
    return uri
        .replace(
          queryParameters: {
            ...uri.queryParameters,
            'w': ImageScreenConstants.imageWidth,
            'q': ImageScreenConstants.imageQuality,
          },
        )
        .toString();
  }

  Color _getTextColorForBackground() {
    if (_backgroundColor == null) {
      return Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black;
    }
    // Calculate luminance: if > 0.5, background is light, use dark text
    return _backgroundColor!.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  Future<void> _updatePalette(
    ImageProvider imageProvider,
    String imageUrl,
  ) async {
    if (_lastProcessedUrl == imageUrl) return;
    _lastProcessedUrl = imageUrl;

    // Reset opacity for new image
    setState(() {
      _imageOpacity = 0.0;
    });

    try {
      final palette = await PaletteGenerator.fromImageProvider(
        imageProvider,
        maximumColorCount: ImageScreenConstants.maxPaletteColors,
      );
      if (mounted && _lastProcessedUrl == imageUrl) {
        setState(() {
          _backgroundColor =
              palette.dominantColor?.color ?? palette.vibrantColor?.color;
          _imageOpacity = 1.0;
        });
      }
    } catch (e) {
      // Fail silently or set default color
      if (mounted) {
        setState(() {
          _imageOpacity = 1.0;
        });
      }
    }
  }

  Widget _buildImagePlaceholder() {
    return const SizedBox(
      width: ImageScreenConstants.imageSize,
      height: ImageScreenConstants.imageSize,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildImageError() {
    return Container(
      width: ImageScreenConstants.imageSize,
      height: ImageScreenConstants.imageSize,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(
          ImageScreenConstants.imageBorderRadius,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            size: ImageScreenConstants.errorIconSize,
            color: Colors.grey[600],
          ),
          const SizedBox(height: ImageScreenConstants.errorSpacingMedium),
          Text(
            ImageScreenConstants.errorMessagePrimary,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: ImageScreenConstants.errorSpacingSmall),
          Text(
            ImageScreenConstants.errorMessageSecondary,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: ImageScreenConstants.errorSecondaryFontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer(ImageProvider imageProvider) {
    return Semantics(
      label: ImageScreenConstants.imageSemanticLabel,
      image: true,
      child: AnimatedOpacity(
        opacity: _imageOpacity,
        duration: ImageScreenConstants.imageFadeDuration,
        child: Container(
          width: ImageScreenConstants.imageSize,
          height: ImageScreenConstants.imageSize,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(
              ImageScreenConstants.imageBorderRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(ImageScreenConstants.shadowAlpha),
                blurRadius: ImageScreenConstants.shadowBlurRadius,
                offset: ImageScreenConstants.shadowOffset,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageState = ref.watch(randomImageProvider);

    return AnimatedContainer(
      duration: ImageScreenConstants.backgroundTransitionDuration,
      color: _backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Semantics(
            header: true,
            child: Text(
              ImageScreenConstants.appTitle,
              style: TextStyle(color: _getTextColorForBackground()),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: imageState.when(
                    data: (imageResponse) {
                      final optimizedUrl = _buildOptimizedUrl(
                        imageResponse.url,
                      );

                      return CachedNetworkImage(
                        imageUrl: optimizedUrl,
                        imageBuilder: (context, imageProvider) {
                          // Trigger palette update when image is loaded
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _updatePalette(imageProvider, optimizedUrl);
                          });

                          return _buildImageContainer(imageProvider);
                        },
                        placeholder: (context, url) => _buildImagePlaceholder(),
                        errorWidget: (context, url, error) =>
                            _buildImageError(),
                      );
                    },
                    loading: _buildImagePlaceholder,
                    error: (error, stack) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error,
                          size: ImageScreenConstants.errorIconSize,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          height: ImageScreenConstants.errorSpacingLarge,
                        ),
                        Text('Error: $error'),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(
                  ImageScreenConstants.buttonPadding,
                ),
                child: Semantics(
                  button: true,
                  enabled: !imageState.isLoading,
                  label: imageState.isLoading
                      ? ImageScreenConstants.buttonSemanticLabelLoading
                      : ImageScreenConstants.buttonSemanticLabelIdle,
                  child: SizedBox(
                    width: double.infinity,
                    height: ImageScreenConstants.buttonHeight,
                    child: ElevatedButton(
                      onPressed: imageState.isLoading
                          ? null
                          : () {
                              ref
                                  .read(randomImageProvider.notifier)
                                  .fetchNewImage();
                            },
                      child: imageState.isLoading
                          ? const SizedBox(
                              width: ImageScreenConstants.loadingIndicatorSize,
                              height: ImageScreenConstants.loadingIndicatorSize,
                              child: CircularProgressIndicator(
                                strokeWidth:
                                    ImageScreenConstants.loadingIndicatorStroke,
                              ),
                            )
                          : const Text(ImageScreenConstants.buttonLabel),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
