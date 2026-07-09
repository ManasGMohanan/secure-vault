# SecureVault

SecureVault is a production-quality, offline-first password manager built in Flutter. It allows users to securely store, organize, retrieve, and generate credentials for their accounts, backed by strong local database encryption and biometric convenience.

## Architecture Decisions (ADR)

- **Feature-First Organization:** The codebase is structured around features (auth, vault, password_generator, settings) rather than technical layers. Each feature contains its own data, domain, and presentation components.
- **Riverpod Code Generation:** We use `@riverpod` annotations and `riverpod_generator` for state management, eliminating manual provider declarations and boilerplate.
- **Concrete Repositories (No Interfaces):** Repositories are concrete classes exposed via Riverpod providers. Interfaces are avoided as there is only one production implementation.
- **No UseCase Classes:** Simple business logic flows directly from widgets to Notifiers to Repositories.
- **Freezed for Models:** Freezed is used for all entities, data transfer objects (DTOs), and sealed state definitions.
- **Hive CE Encryption:** Vault entries are stored in a Hive CE box encrypted with `HiveAesCipher` using a 256-bit AES key derived from the user's master password.
- **No Master Password Persistence:** The master password itself is never stored. We derive a 256-bit key using PBKDF2 (100,000 iterations, SHA-256 HMAC) from the password and a secure 16-byte random salt. Password correctness is checked by comparing the SHA-256 hash of the derived key against a hash stored in `flutter_secure_storage`.
- **Biometric Unlock convenience:** If enabled, the derived encryption key is stored in the device's secure Keychain/Keystore (via `flutter_secure_storage`) and retrieved upon successful biometric challenge (`local_auth`).
- **Clean DTO/Entity Seams:** The repository maps Hive-compatible DTOs (`VaultEntryModel` JSON) to domain entities (`VaultEntry`). The presentation layer only ever consumes domain entities.
- **Error Propagation:** Failures are caught at the repository layer and converted to custom `Failure` exceptions, which are propagated to the UI using Riverpod's `AsyncValue` (`AsyncError`).
- **Centralized Navigation Architecture:** GoRouter configuration is housed in `/lib/core/routing/` containing `app_router.dart`, `gorouter_extension.dart`, and `router_transition.dart`. This decouples individual features from routing logic, centralizes route definitions and authorization redirects, allows reuse of custom transitions (slides, fades), and exposes type-safe navigation extensions on `BuildContext` (e.g. `context.goToEntryDetail(id)`).

## Setup & Running Instructions

### 1. Prerequisites

- Flutter SDK (v3.13 or newer)
- Xcode (for iOS testing) or Android Studio (for Android testing)

### 2. Install Dependencies

In the project root (`secure_vault`), run:

```bash
flutter pub get
```

### 3. Running Code Generation

To generate Freezed models and Riverpod provider code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

To watch for file changes during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### 4. Running Tests

Run the unit and widget test suite:

```bash
flutter test
```

### 5. Running the Application

To run the application on an emulator or connected device:

```bash
flutter run
```
