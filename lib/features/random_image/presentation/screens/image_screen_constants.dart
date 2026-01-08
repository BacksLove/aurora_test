import 'package:flutter/material.dart';

@immutable
class ImageScreenConstants {
  const ImageScreenConstants._();

  static const image = _ImageConstants();
  static const animation = _AnimationConstants();
  static const layout = _LayoutConstants();
  static const strings = _StringConstants();
  static const styles = _StyleConstants();
}

@immutable
class _ImageConstants {
  const _ImageConstants();

  double get size => 300.0;
  double get borderRadius => 16.0;
  String get optimizationWidth => '600';
  String get optimizationQuality => '80';
  int get maxPaletteColors => 20;

  BoxShadow get shadow => BoxShadow(
    color: Colors.black.withAlpha(51),
    blurRadius: 10.0,
    offset: const Offset(0, 5),
  );

  BoxDecoration errorDecoration(BuildContext context) => BoxDecoration(
    color: Colors.grey[300],
    borderRadius: BorderRadius.circular(borderRadius),
  );
}

@immutable
class _AnimationConstants {
  const _AnimationConstants();

  Duration get backgroundTransition => const Duration(milliseconds: 500);
  Duration get imageFade => const Duration(milliseconds: 300);
}

@immutable
class _LayoutConstants {
  const _LayoutConstants();

  double get errorIconSize => 50.0;
  double get buttonHeight => 50.0;
  double get buttonPadding => 32.0;
  double get loadingIndicatorSize => 24.0;
  double get loadingIndicatorStroke => 2.0;

  EdgeInsets get buttonPaddingInsets => EdgeInsets.all(buttonPadding);

  double get spacingLarge => 16.0;
  double get spacingMedium => 8.0;
  double get spacingSmall => 4.0;

  SizedBox get spacingLargeBox => SizedBox(height: spacingLarge);
  SizedBox get spacingMediumBox => SizedBox(height: spacingMedium);
  SizedBox get spacingSmallBox => SizedBox(height: spacingSmall);
}

@immutable
class _StringConstants {
  const _StringConstants();

  String get appTitle => 'Random Image';
  String get imageSemanticLabel => 'Random image from Unsplash';
  String get buttonLabel => 'Another';
  String get buttonSemanticLabelIdle => 'Load another random image';
  String get buttonSemanticLabelLoading => 'Loading new image';
  String get errorMessagePrimary => 'Image failed to load';
  String get errorMessageSecondary => 'Tap "Another" to try again';
  String errorFormat(Object error) => 'Error: $error';
}

@immutable
class _StyleConstants {
  const _StyleConstants();

  TextStyle errorPrimaryStyle(BuildContext context) =>
      TextStyle(color: Colors.grey[600], fontSize: 14.0);

  TextStyle errorSecondaryStyle(BuildContext context) =>
      TextStyle(color: Colors.grey[500], fontSize: 12.0);

  Color errorIconColor(BuildContext context) => Colors.grey[600]!;
}
