# Random Image Mobile App

A Flutter mobile application that displays random images with dynamic color-adaptive UI.

## 📋 Project Objective

This project is a technical assignment demonstrating:

- Clean Architecture implementation in Flutter
- State management with Riverpod
- Comprehensive error handling with typed failures
- Robust testing strategy covering edge cases
- Production-ready UI/UX with dark/light mode support

## 🏗️ Architecture

The project follows **Clean Architecture** principles with clear separation of concerns:

### Layer Structure

```text
lib/
├── core/
│   ├── errors/           # Failure types and Result pattern
│   │   ├── failures.dart # NetworkFailure, ServerFailure, TimeoutFailure, etc.
│   │   └── result.dart   # Result<T> sealed class (Success/Error)
│   ├── network/          # HTTP client configuration
│   └── constants/        # API constants
│
└── features/
    └── random_image/
        ├── domain/       # Business logic layer
        │   ├── repositories/  # Repository interfaces
        │   └── usecases/      # Business rules (GetRandomImageUseCase)
        │
        ├── data/         # Data layer
        │   ├── models/        # Data models (Freezed)
        │   └── repositories/  # Repository implementations
        │
        └── presentation/ # UI layer
            ├── providers/     # State management (Riverpod)
            └── screens/       # UI components
```

### Key Architectural Decisions

#### 1. **Clean Architecture with UseCases**

- **Domain Layer**: Contains business logic and rules
  - `GetRandomImageUseCase`: Validates image URLs (non-empty, HTTP/HTTPS, valid host)
  - Repository interfaces define contracts
- **Data Layer**: Implements data fetching and error mapping
  - Maps `DioException` to domain-specific `Failure` types
  - Returns `Result<T>` instead of throwing exceptions
- **Presentation Layer**: Consumes UseCases through Riverpod providers

#### 2. **Functional Error Handling**

- **Result Pattern**: `Result<T>` sealed class with `Success<T>` and `Error<T>`
- **Typed Failures**: Each error type carries semantic meaning
  - `NetworkFailure`: Connection issues
  - `ServerFailure`: HTTP 4xx/5xx errors with status codes
  - `TimeoutFailure`: Connection/receive timeouts
  - `UnexpectedFailure`: Parsing errors, invalid data
- **Benefits**: Type-safe error handling, no exception leakage across layers

#### 3. **State Management with Riverpod**

- Code generation with `riverpod_annotation` for type safety
- `AsyncNotifier` pattern for async state
- Providers for dependency injection throughout the app

## 🛠️ Technology Choices

### Why Dio?

- **Interceptors**: Automatic retry logic for timeout errors
- **Better error handling**: Rich exception types (`DioException`) with detailed error info
- **Request/Response transformation**: Easy to add logging, authentication
- **Timeout configuration**: Fine-grained control (connection, send, receive timeouts)
- **Cancellation support**: Request cancellation tokens
- **Better than http package**: More features, better DX, production-ready

### Why Freezed?

- **Immutable data models**: Safer state management
- **Code generation**: Reduces boilerplate for `copyWith`, `==`, `hashCode`
- **Union types**: Perfect for sealed classes and pattern matching
- **JSON serialization**: Seamless integration with `json_serializable`
- **Type safety**: Compile-time guarantees for data integrity

### Other Key Dependencies

- **cached_network_image**: Image caching with automatic memory management
- **palette_generator**: Extract dominant colors from images for adaptive UI
- **mocktail**: Elegant mocking for tests without code generation
- **riverpod_annotation**: Type-safe providers with code generation

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: >=3.6.1 <4.0.0
- Dart SDK: >=3.6.1 <4.0.0

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd mobile_engineer_assignment
   ```

1. **Install dependencies**

   ```bash
   flutter pub get
   ```

1. **Generate code** (for Freezed, Riverpod, JSON serialization)

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

1. **Run the app**

   ```bash
   flutter run
   ```

### Available Scripts

- `flutter run`: Launch the app on connected device/emulator
- `flutter run -d chrome`: Run on web browser
- `dart run build_runner watch`: Watch for changes and regenerate code
- `dart run build_runner build --delete-conflicting-outputs`: One-time code generation

## 🧪 Testing

The project includes comprehensive test coverage across all layers.

### Test Structure

```text
test/
└── features/
    └── random_image/
        ├── domain/
        │   └── usecases/
        │       └── get_random_image_usecase_test.dart (12 tests)
        ├── data/
        │   └── repositories/
        │       └── image_repository_impl_test.dart (10 tests)
        └── presentation/
            ├── providers/
            │   └── random_image_provider_test.dart (7 tests)
            └── screens/
                └── image_screen_test.dart (3 tests)
```

### Running Tests

**Run all tests:**

```bash
flutter test
```

**Run specific test file:**

```bash
flutter test test/features/random_image/domain/usecases/get_random_image_usecase_test.dart
```

**Run tests with coverage:**

```bash
flutter test --coverage
```

**View coverage report:**

```bash
# Install lcov if not already installed (macOS)
brew install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

### Test Coverage Highlights

**Total: 32 tests** covering:

- ✅ **UseCase (12 tests)**: Business rule validation (URL format, scheme, host)
- ✅ **Repository (10 tests)**: Network errors, timeouts, HTTP codes, invalid data
- ✅ **Provider (7 tests)**: State management, loading/error/success states
- ✅ **UI (3 tests)**: Widget rendering, loading states, error display

**Coverage areas:**

- Happy path scenarios
- Network failures (connection errors, DNS errors)
- Timeout scenarios (connection, send, receive)
- HTTP errors (404, 500, etc.)
- Invalid/null response data
- Business rule violations
- State transitions

## 🎨 Features

- **Random Image Display**: Fetches and displays random images from API
- **Adaptive UI**: Background color adapts to image palette
- **Text Color Adaptation**: Text color adjusts based on background luminance for accessibility
- **Smooth Animations**: 500ms background transitions, 300ms image fade-in
- **Dark/Light Mode**: Full theme support
- **Error Handling**: User-friendly error messages with retry option
- **Offline Support**: Image caching for better performance
- **Accessibility**: Semantic labels for screen readers

## 📦 API

The app consumes the following API endpoint:

- **Base URL**: `https://november7-730026606190.europe-west1.run.app`
- **Endpoint**: `GET /image`
- **Response**: `{ "url": "https://..." }`

Image optimization parameters:

- Width: 600px
- Quality: 80%

## 🔧 Configuration

### Network Settings

- **Connection Timeout**: 30 seconds
- **Receive Timeout**: 30 seconds
- **Retry Logic**: Automatic retry on timeout (1 retry)

### Caching

- **Image Cache**: 7 days (default)
- **Cache Strategy**: Memory + Disk cache

## 📝 Code Quality

- **Linting**: Analysis options configured for Flutter best practices
- **Formatting**: Dart format with 80-character line limit
- **Immutability**: All models use Freezed for immutable state
- **Type Safety**: Leverages Dart 3 features (sealed classes, pattern matching)
- **Documentation**: Comprehensive inline documentation for public APIs

## 🏆 Best Practices Implemented

1. **Separation of Concerns**: Clear layer boundaries with dependency inversion
2. **Single Responsibility**: Each class has one reason to change
3. **Dependency Injection**: All dependencies injected through Riverpod
4. **Error Handling**: No thrown exceptions across layer boundaries
5. **Testability**: High test coverage with isolated unit tests
6. **Code Generation**: Reduces boilerplate and human error
7. **Immutability**: Safer state management with Freezed
8. **Accessibility**: WCAG-compliant text contrast ratios

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Linux
- ✅ Windows

## 📄 License

This project is part of a technical assignment.

