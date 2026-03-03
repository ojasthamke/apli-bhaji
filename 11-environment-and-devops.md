# Environment and DevOps
Project: APLI BHAJI
Date: 2026-03-03

This document outlines the development environment setup and the simplified DevOps process for the APLI BHAJI offline application.

## Development Environment Setup

### 1. Prerequisites
- **Operating System**: Windows, macOS, or Linux.
- **Flutter SDK**: Stable channel (latest version).
- **Android Studio**: Installed with Android SDK, Command-line Tools, and Build-tools.
- **VS Code** (Optional): With Flutter and Dart extensions.
- **Git**: For version control.

### 2. Project Initialization
- Clone the repository: `git clone <repository-url>`
- Install dependencies: `flutter pub get`
- Run the app on an emulator or physical device: `flutter run`

## Development Workflow

- **Branching Strategy**: Use a simple branching model like GitFlow or Feature Branching.
  - `main`: Production-ready code.
  - `develop`: Ongoing development.
  - `feature/*`: Specific feature development.
- **Code Style**: Follow official [Dart style guide](https://dart.dev/guides/language/effective-dart/style).
- **State Management**: Consistently use Riverpod for state and dependency injection.

## Build and Distribution (CI/CD)

Since this is a fully offline app, the DevOps focus is on local build stability and manual distribution.

### 1. Manual Build
- Generate a release APK: `flutter build apk --release`
- Generate an App Bundle (for Play Store): `flutter build appbundle`

### 2. Local CI (Optional)
- Pre-commit hooks to run `flutter analyze` and `flutter test`.

### 3. Distribution
- **Internal Testing**: Distribute APKs via WhatsApp or Firebase App Distribution.
- **Production**: Upload the `.aab` file to the Google Play Console.

## Environment Configurations

As the app is 100% offline, there are no environment-specific (Dev, Staging, Prod) API endpoints. Configuration is primarily managed via `pubspec.yaml` and internal constant files.
