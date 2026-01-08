library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_response.freezed.dart';
part 'image_response.g.dart';

@freezed
abstract class ImageResponse with _$ImageResponse {
  /// Private constructor for Freezed to enable custom methods if needed
  const ImageResponse._();

  /// Factory constructor for creating an ImageResponse instance
  const factory ImageResponse({required String url}) = _ImageResponse;

  /// Factory constructor for creating an ImageResponse instance from JSON
  factory ImageResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageResponseFromJson(json);
}
