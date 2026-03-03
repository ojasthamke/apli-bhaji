# Testing Strategy
Project: APLI BHAJI
Date: 2026-03-03

This document defines the testing strategy for the APLI BHAJI application to ensure high quality, stability, and performance.

## Testing Objectives

- **Stability**: Ensure the app does not crash during core user journeys.
- **Accuracy**: Validate that all billing and discount calculations are 100% accurate.
- **Offline Integrity**: Verify that data is correctly persisted to and retrieved from the SQLite database.
- **Performance**: Confirm that the app meets the defined performance goals (launch < 2s, save < 200ms).

## Testing Levels

### 1. Unit Testing
- **Focus**: Testing individual functions, methods, and classes in isolation.
- **Target Areas**:
    - Scoring/Calculation engine (Order totals, discounts).
    - Data models (serialization/deserialization).
    - Utility functions (date formatting, string manipulation).
- **Tools**: `test` package, `mockito` for mocking dependencies.

### 2. Widget Testing
- **Focus**: Testing individual UI components and their interactions.
- **Target Areas**:
    - Custom buttons, text fields, and list tiles.
    - Screen layouts and navigation triggers.
    - State management (Riverpod providers) correctly updating the UI.
- **Tools**: `flutter_test` package.

### 3. Integration Testing
- **Focus**: Testing complete user flows across multiple screens and layers.
- **Target Areas**:
    - Create Area -> Create Customer -> Create Order -> Generate PDF.
    - Backup Database -> Delete Data -> Restore Database.
- **Tools**: `integration_test` package.

### 4. Manual/User Acceptance Testing (UAT)
- **Focus**: Verifying that the app meets the business requirements and user needs.
- **Target Areas**:
    - Visual consistency with the "Black minimal UI".
    - Ease of use and intuitive navigation.
    - Real-world device testing (different screen sizes, Android versions).
    - WhatsApp sharing flow.

## Performance Testing

- **Startup Time**: Measured using Flutter performance tools to ensure < 2s launch.
- **Database Performance**: Testing with 1000+ customers and 10,000+ orders to ensure queries remain fast and efficient.
- **Memory Usage**: Monitoring for memory leaks, especially during PDF generation and image loading.

## Bug Reporting and Tracking

For the MVP phase, bugs will be tracked using a simple issue tracker (e.g., GitHub Issues or a shared spreadsheet) with the following details:
- **Title**: Brief description of the bug.
- **Steps to Reproduce**: Detailed list of actions taken.
- **Expected Result**: What should have happened.
- **Actual Result**: What actually happened (including screenshots/logs).
- **Severity**: Critical, Major, Minor, or Tweak.
