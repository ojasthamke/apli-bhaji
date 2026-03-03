# Monorepo Structure
Project: APLI BHAJI
Date: 2026-03-03

This document describes the directory and file structure of the APLI BHAJI Flutter project.

## High-Level Structure

```text
apli_bhaji/
├── android/            # Android-specific configuration and code
├── ios/                # iOS-specific configuration and code (not primary focus)
├── lib/                # Main application code (Flutter)
│   ├── core/           # Shared components and utilities
│   │   ├── constants/  # App-wide constants (colors, strings, etc.)
│   │   ├── database/   # Database initialization and management (sqflite)
│   │   ├── utils/      # General-purpose utility functions
│   │   └── widgets/    # Reusable Flutter widgets
│   ├── features/       # Feature-based modular structure
│   │   ├── areas/      # Area Management feature
│   │   ├── customers/  # Customer Management feature
│   │   ├── items/      # Item Management (Vegetables/Medicines) feature
│   │   ├── orders/     # Order & Billing feature
│   │   ├── reports/    # Reports feature
│   │   └── settings/   # Settings, Backup & Restore feature
│   └── main.dart       # Application entry point
├── test/               # Unit, widget, and integration tests
├── assets/             # Static assets like images, fonts, etc.
│   ├── images/         # App-specific images
│   └── icons/          # Custom icons
├── pubspec.yaml        # Flutter project configuration and dependencies
└── README.md           # Project overview and setup instructions
```

## Feature-Specific Structure (e.g., `lib/features/areas/`)

Each feature follows a consistent internal structure:

```text
areas/
├── data/               # Data layer (repositories and models)
│   ├── models/         # Data models (e.g., Area model)
│   └── repositories/   # Data access logic (DB calls)
├── domain/             # Domain layer (business logic and interfaces)
│   └── entities/       # Domain entities
└── presentation/       # Presentation layer (UI and state management)
    ├── providers/      # Riverpod state providers
    ├── screens/        # Main screens for the feature
    └── widgets/        # Feature-specific reusable widgets
```
