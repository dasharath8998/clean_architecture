# Flutter Clean Architecture App

A production-ready Flutter application demonstrating Clean Architecture, BLoC state management, GetIt dependency injection, and GoRouter navigation — fully supporting Android, iOS, and Flutter Web with responsive UI.

---

## Tech Stack

| Concern | Package |
|---|---|
| State Management | `flutter_bloc` + `bloc` |
| Dependency Injection | `get_it` |
| Navigation | `go_router` |
| Persistence | `shared_preferences` |
| Equality | `equatable` |

---

## Architecture

The project follows Clean Architecture with strict separation of concerns across three layers:

```text
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│   BLoC · Screens · Widgets · Router     │
├─────────────────────────────────────────┤
│           Domain Layer                  │
│   Entities · Repositories (abstract)   │
│   Use Cases                             │
├─────────────────────────────────────────┤
│            Data Layer                   │
│   Models · Remote/Local DataSources     │
│   Repository Implementations            │
└─────────────────────────────────────────┘
```

Key principle: The Domain layer has zero Flutter/external dependencies. The Presentation layer never talks directly to the Data layer — everything goes through the Domain contracts.

---

## Folder Structure

```text
lib/
├── core/                          # Shared infrastructure (no feature logic)
│   ├── constants/
│   │   ├── app_colors.dart        # Central color palette
│   │   ├── app_strings.dart       # All string literals
│   │   ├── app_sizes.dart         # Spacing, radii, breakpoints
│   │   ├── app_routes.dart        # Route names & paths
│   │   └── api_constants.dart     # Endpoints, timeouts, mock OTP
│   ├── theme/
│   │   └── app_theme.dart         # Material 3 ThemeData
│   ├── widgets/                   # Reusable common widgets
│   │   ├── common_button.dart
│   │   ├── common_text_field.dart
│   │   ├── common_loader.dart
│   │   └── common_snackbar.dart
│   ├── network/
│   │   └── api_client.dart        # Abstract ApiClient + MockApiClient
│   ├── storage/
│   │   ├── local_storage.dart     # Storage abstraction
│   │   └── shared_preferences_storage.dart
│   ├── error/
│   │   ├── failures.dart          # Domain-level failure types
│   │   └── exceptions.dart        # Data-layer exception types
│   ├── utils/
│   │   ├── use_case.dart          # Abstract UseCase base class
│   │   ├── validators.dart        # Form validators
│   │   └── responsive_helper.dart # Responsive layout utilities
│   ├── extensions/
│   │   ├── string_extensions.dart
│   │   └── context_extensions.dart
│   ├── di/
│   │   └── injection_container.dart  # GetIt service locator setup
│   ├── router/
│   │   └── app_router.dart           # GoRouter with guards
│   └── core.dart                     # Barrel export
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_data_source.dart
│   │   │   │   └── auth_local_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── auth_models.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_use_case.dart
│   │   │       ├── verify_otp_use_case.dart
│   │   │       └── logout_use_case.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── login/
│   │       │   │   ├── login_bloc.dart
│   │       │   │   ├── login_event.dart
│   │       │   │   └── login_state.dart
│   │       │   └── otp/
│   │       │       ├── otp_bloc.dart
│   │       │       ├── otp_event.dart
│   │       │       └── otp_state.dart
│   │       └── screens/
│   │           ├── login_screen.dart
│   │           └── otp_screen.dart
│   │
│   ├── home/
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── home_bloc.dart
│   │       │   ├── home_event.dart
│   │       │   └── home_state.dart
│   │       └── screens/
│   │           ├── home_screen.dart
│   │           ├── home_tab_screen.dart
│   │           └── search_tab_screen.dart
│   │
│   ├── profile/
│   │   └── presentation/
│   │       └── screens/
│   │           └── profile_screen.dart
│   │
│   └── splash/
│       └── presentation/
│           └── screens/
│               └── splash_screen.dart
│
├── main.dart
web/
├── index.html
└── manifest.json
```

---

## Key Design Decisions

### 1. Mock → Real API: Zero Presentation Changes

The `ApiClient` abstract class is the only entry point from the data layer to network.

```dart
// In injection_container.dart — change only this one line:
sl.registerLazySingleton<ApiClient>(() => MockApiClient());

// becomes:

sl.registerLazySingleton<ApiClient>(
  () => DioApiClient(baseUrl: ApiConstants.baseUrl),
);
```

Nothing else changes — BLoC, UseCases, Repository interfaces are untouched.

### 2. GoRouter Query Parameters (Login → OTP)

```dart
context.goNamed(
  AppRoutes.otp,
  queryParameters: {AppRoutes.mobileParam: mobile},
);

// OTP route reads it:
final mobile = state.uri.queryParameters[AppRoutes.mobileParam] ?? '';
```

Web URL example:

```text
https://yourapp.com/otp?mobile=9876543210
```

### 3. Route Guard (Authentication)

`AppRouter._routeGuard` checks `SharedPreferences` on every navigation:

- Unauthenticated → protected routes redirect to `/login`
- Authenticated → auth routes redirect to `/home`

### 4. LocalStorage Abstraction

`LocalStorage` abstract class means you can swap `SharedPreferences` with `Hive`, `SecureStorage`, or `SQLite` without touching a single feature file.

### 5. BLoC Lifecycle

BLoCs are registered as factory in GetIt — each route gets a fresh BLoC instance.

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.10.0`
- Dart SDK `>=3.0.0`

### Setup

```bash
# Clone the repo
git clone https://github.com/dasharath8998/clean_architecture.git
cd clean_architecture

# Install dependencies
flutter pub get

# Run on Android/iOS
flutter run

# Run on Chrome (Web)
flutter run -d chrome

# Build for web
flutter build web --release
```

---

## Mock OTP

The static OTP for demo is:

```text
123456
```

Configured in `ApiConstants.validOtp`.

---

## Screens

| Screen | Route | Notes |
|---|---|---|
| Splash | `/` | Auth check, animated |
| Login | `/login` | 10-digit mobile validation |
| OTP | `/otp?mobile=XXXXXXXXXX` | Query param, static OTP |
| Home | `/home` | Bottom tab bar |
| Profile | Tab inside `/home` | Dummy user info, logout |

---

## Auth Flow

```text
App Launch
    │
    ▼
Splash Screen
    │
    ├── isLoggedIn == true ───────► Home Screen
    │
    └── isLoggedIn == false ──────► Login Screen
                                         │
                                         ▼
                                    OTP Screen
                                    (?mobile=XXXXXXXXXX)
                                         │
                                         ▼ OTP: 123456
                                    Home Screen
```

---

## Web Responsiveness

```dart
ResponsiveWrapper(
  maxWidth: AppSizes.maxContentWidth,
  child: YourContent(),
)
```

---

## Checklist

- [x] Clean Architecture
- [x] BLoC state management
- [x] GetIt dependency injection
- [x] GoRouter navigation
- [x] Query parameters support
- [x] Route guards
- [x] Splash screen
- [x] Login validation
- [x] OTP verification
- [x] Home screen with tabs
- [x] Logout flow
- [x] SharedPreferences persistence
- [x] Mock API support
- [x] Responsive Web UI
- [x] Material 3 theme
- [x] Android, iOS, Web support