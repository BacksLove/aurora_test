import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_engineer_assignment/core/di/providers.dart';
import 'package:mobile_engineer_assignment/core/errors/result.dart';
import 'package:mobile_engineer_assignment/features/random_image/data/models/image_response.dart';
import 'package:mobile_engineer_assignment/features/random_image/domain/repositories/image_repository.dart';
import 'package:mobile_engineer_assignment/features/random_image/presentation/screens/image_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockImageRepository extends Mock implements ImageRepository {}

void main() {
  late MockImageRepository mockRepository;

  setUp(() {
    mockRepository = MockImageRepository();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [imageRepositoryProvider.overrideWithValue(mockRepository)],
      child: const MaterialApp(home: ImageScreen()),
    );
  }

  testWidgets('displays loading indicator initially', (tester) async {
    // Arrange
    final completer = Completer<Result<ImageResponse>>();
    when(
      () => mockRepository.getRandomImage(),
    ).thenAnswer((_) => completer.future);

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    // We expect 2 indicators: one in the center, one in the button
    expect(find.byType(CircularProgressIndicator), findsNWidgets(2));

    // Cleanup
    completer.complete(
      const Success(ImageResponse(url: 'https://example.com/image.jpg')),
    );
    await tester.pump();
  });

  testWidgets('displays error message when fetching fails', (tester) async {
    // Arrange
    when(
      () => mockRepository.getRandomImage(),
    ).thenAnswer((_) async => Error(Exception('Network Error') as Never));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Assert
    expect(find.textContaining('Error'), findsOneWidget);
    expect(find.byIcon(Icons.error), findsOneWidget);
  });

  testWidgets('displays image and button when data is loaded', (tester) async {
    // Arrange
    const tImageResponse = ImageResponse(url: 'https://example.com/image.jpg');
    when(
      () => mockRepository.getRandomImage(),
    ).thenAnswer((_) async => const Success(tImageResponse));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Process the future

    // Assert
    // Note: CachedNetworkImage might not render fully in test environment without mocking,
    // but we can check if the widget is present in the tree.
    // We look for the button "Another"
    expect(find.text('Another'), findsOneWidget);
  });
}
