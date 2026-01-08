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
            'w': ImageScreenConstants.image.optimizationWidth,
            'q': ImageScreenConstants.image.optimizationQuality,
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
        maximumColorCount: ImageScreenConstants.image.maxPaletteColors,
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
    return SizedBox(
      width: ImageScreenConstants.image.size,
      height: ImageScreenConstants.image.size,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildImageError() {
    return Container(
      width: ImageScreenConstants.image.size,
      height: ImageScreenConstants.image.size,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(
          ImageScreenConstants.image.borderRadius,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            size: ImageScreenConstants.layout.errorIconSize,
            color: Colors.grey[600],
          ),
          SizedBox(height: ImageScreenConstants.layout.spacingMedium),
          Text(
            ImageScreenConstants.strings.errorMessagePrimary,
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: ImageScreenConstants.layout.spacingSmall),
          Text(
            ImageScreenConstants.strings.errorMessageSecondary,
            style: TextStyle(color: Colors.grey[500], fontSize: 12.0),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer(ImageProvider imageProvider) {
    return Semantics(
      label: ImageScreenConstants.strings.imageSemanticLabel,
      image: true,
      child: AnimatedOpacity(
        opacity: _imageOpacity,
        duration: ImageScreenConstants.animation.imageFade,
        child: Container(
          width: ImageScreenConstants.image.size,
          height: ImageScreenConstants.image.size,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(
              ImageScreenConstants.image.borderRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(51),
                blurRadius: 10.0,
                offset: const Offset(0, 5),
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
      duration: ImageScreenConstants.animation.backgroundTransition,
      color: _backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Semantics(
            header: true,
            child: Text(
              ImageScreenConstants.strings.appTitle,
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
                        Icon(
                          Icons.error,
                          size: ImageScreenConstants.layout.errorIconSize,
                          color: Colors.red,
                        ),
                        SizedBox(
                          height: ImageScreenConstants.layout.spacingLarge,
                        ),
                        Text('Error: $error'),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  ImageScreenConstants.layout.buttonPadding,
                ),
                child: Semantics(
                  button: true,
                  enabled: !imageState.isLoading,
                  label: imageState.isLoading
                      ? ImageScreenConstants.strings.buttonSemanticLabelLoading
                      : ImageScreenConstants.strings.buttonSemanticLabelIdle,
                  child: SizedBox(
                    width: double.infinity,
                    height: ImageScreenConstants.layout.buttonHeight,
                    child: ElevatedButton(
                      onPressed: imageState.isLoading
                          ? null
                          : () {
                              ref
                                  .read(randomImageProvider.notifier)
                                  .fetchNewImage();
                            },
                      child: imageState.isLoading
                          ? SizedBox(
                              width: ImageScreenConstants
                                  .layout
                                  .loadingIndicatorSize,
                              height: ImageScreenConstants
                                  .layout
                                  .loadingIndicatorSize,
                              child: CircularProgressIndicator(
                                strokeWidth: ImageScreenConstants
                                    .layout
                                    .loadingIndicatorStroke,
                              ),
                            )
                          : Text(ImageScreenConstants.strings.buttonLabel),
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
