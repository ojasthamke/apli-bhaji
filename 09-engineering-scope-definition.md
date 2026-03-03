# Engineering Scope Definition
Project: APLI BHAJI
Date: 2026-03-03

This document defines the engineering scope for the MVP of the APLI BHAJI application.

## In-Scope Features

The MVP will focus on delivering the following core functionalities:

1.  **Area and Customer CRUD**
    *   Complete implementation of add, view, update, and delete operations for Areas and Customers.
2.  **Item Management**
    *   Implementation of the items module with a toggle to switch between 'Vegetable' and 'Medicine' categories.
3.  **Order Creation and Billing**
    *   A fully functional order creation screen where users can add items and quantities.
    *   Real-time calculation of totals and discounts.
4.  **PDF Invoice Generation**
    *   Creation of a professional PDF invoice from a saved order.
5.  **WhatsApp Sharing**
    *   Integration with `share_plus` to allow sharing the generated PDF via WhatsApp.
6.  **Database and Backup/Restore**
    *   Full SQLite integration using `sqflite`.
    *   Implementation of the backup (export to JSON) and restore (import from JSON) feature.

## Out-of-Scope Features (Post-MVP)

The following features are not part of the MVP scope and will be considered for future releases:

1.  **Telegram Sharing**: While specified in the PRD, initial MVP will focus only on WhatsApp for simplicity.
2.  **Advanced Reports**: The MVP will only include basic reports. Detailed analytics and graphical representations are out of scope.
3.  **Cloud Sync**: The application is 100% offline for the MVP. Any cloud synchronization is out of scope.
4.  **Multi-user Support**: The app is designed for a single user/business owner.
5.  **iOS Support**: While Flutter is cross-platform, the primary focus and testing will be on Android.

## Technology Stack

*   **Language**: Dart
*   **Framework**: Flutter
*   **State Management**: Riverpod
*   **Database**: SQLite (`sqflite`)
*   **PDF Generation**: `pdf` and `printing` packages
*   **Sharing**: `share_plus`
*   **Image Handling**: `image_picker` for customer/area photos
