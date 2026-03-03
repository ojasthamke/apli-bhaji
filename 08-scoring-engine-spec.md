# Scoring and Calculation Engine Specification
Project: APLI BHAJI
Date: 2026-03-03

This document specifies the internal scoring and calculation engine for the APLI BHAJI application.

## Core Calculations

The engine is responsible for performing accurate and fast real-time calculations during order creation and for generating reports.

### 1. Order Calculations

- **`totalAmount`**: The sum of (`quantity` * `price`) for each individual item added to the order.
- **`finalAmount`**: The `totalAmount` minus the user-specified `discount`.
- **`itemTotal`**: The `quantity` * `price` for a specific item in the order.
- **`mrp` vs `price`**: The engine maintains both values but uses the `price` for calculation. It should also be able to show savings based on `mrp` - `price`.

### 2. Discount Logic

- **Flat Discount**: The discount applied is a flat value subtracted from the `totalAmount`.
- **Validation**: The engine must ensure that the `discount` does not exceed the `totalAmount`.

### 3. Report Calculations

- **Total Sales**: The sum of `finalAmount` for all orders within a specific period.
- **Customer Balance**: The sum of unpaid or pending orders for a given customer.
- **Top Selling Items**: A count and sum of items sold across all orders, ranked.

## Performance Requirements

- Calculations should be instantaneous (under 50ms) to ensure smooth UI performance during order creation.
- Calculations should be handled using Dart's `double` and `Decimal` types (using the `decimal` package) to prevent floating-point precision issues.
- All calculations should be done in memory when possible, and results should be persisted to the database only when the order is saved.
