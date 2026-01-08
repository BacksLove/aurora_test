import 'package:flutter/material.dart';

class ImageScreenConstants {
  ImageScreenConstants._();

  // Image dimensions
  static const double imageSize = 300.0;

  // Border radius
  static const double imageBorderRadius = 16.0;

  // Durations
  static const Duration backgroundTransitionDuration = Duration(
    milliseconds: 500,
  );
  static const Duration imageFadeDuration = Duration(milliseconds: 300);

  // Image optimization
  static const String imageWidth = '600';
  static const String imageQuality = '80';

  // Palette generation
  static const int maxPaletteColors = 20;

  // Sizes
  static const double errorIconSize = 50.0;
  static const double buttonHeight = 50.0;
  static const double buttonPadding = 32.0;
  static const double loadingIndicatorSize = 24.0;
  static const double loadingIndicatorStroke = 2.0;

  // Spacing
  static const double errorSpacingLarge = 16.0;
  static const double errorSpacingMedium = 8.0;
  static const double errorSpacingSmall = 4.0;

  // Text styles
  static const double errorSecondaryFontSize = 12.0;

  // Shadow
  static const int shadowAlpha = 51; // 0.2 * 255
  static const double shadowBlurRadius = 10.0;
  static const Offset shadowOffset = Offset(0, 5);

  // Strings
  static const String appTitle = 'Random Image';
  static const String imageSemanticLabel = 'Random image from Unsplash';
  static const String buttonLabel = 'Another';
  static const String buttonSemanticLabelIdle = 'Load another random image';
  static const String buttonSemanticLabelLoading = 'Loading new image';
  static const String errorMessagePrimary = 'Image failed to load';
  static const String errorMessageSecondary = 'Tap "Another" to try again';
}
