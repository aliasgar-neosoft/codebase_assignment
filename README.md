# Codebase Assignment

A Flutter app built using `Clean Architecture` and `Cubit` for state management.`Retrofit` for network calls and `Freezed` for immutable models and state classes.

---

## Project Structure

```
lib/
├── core/
│   ├── error/                     # Common error classes
│   ├── services/
│   │   ├── api_service/          # Network API calls
│   │   ├── db_service/           # Local database layer
│   │   └── network_connectivity/ # Connectivity checker
│   ├── utils/                    # Interceptors, use cases, handlers
│   ├── widget/connectivity_banner/  # Banner to show network status
│   └── di.dart                   # Dependency injection
├── features/                     # Feature-based modules
│   └── <feature_name>/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

---

## Build Runner Commands
To clean and regenerate:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Getting Started

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

---