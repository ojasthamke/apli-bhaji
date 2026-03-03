# Development Phases
Project: APLI BHAJI
Date: 2026-03-03

This document outlines the phased approach for developing the APLI BHAJI application.

## Phase 1: Foundation & Core UI (Weeks 1-2)
- **Project Setup**: Initialize Flutter project, add dependencies (Riverpod, sqflite, etc.).
- **Theme & UI Kit**: Implement the "Black minimal UI" theme and reusable widgets.
- **Database Layer**: Implement SQLite database helper and initial tables (Areas, Customers, Items).
- **Navigation**: Setup the basic navigation structure using the defined Information Architecture.

## Phase 2: Feature Development - Part 1 (Weeks 3-4)
- **Area Management**: Implement CRUD for Areas including photo storage.
- **Customer Management**: Implement CRUD for Customers linked to Areas.
- **Item Management**: Implement the Items module with Vegetable/Medicine toggle and "IsEnabled" logic.

## Phase 3: Billing & Core Logic (Weeks 5-6)
- **Order Creation**: Build the main billing screen with real-time calculations.
- **Scoring Engine**: Implement the logic for totals, discounts, and final amounts.
- **Order History**: View past orders for specific customers.

## Phase 4: Utilities & Final Features (Weeks 7-8)
- **PDF Generation**: Implement the PDF invoice template using the `pdf` package.
- **Sharing**: Integrate `share_plus` for WhatsApp sharing.
- **Backup & Restore**: Implement JSON-based database export and import.
- **Reports**: Build the basic sales and customer balance reports.

## Phase 5: Optimization & Launch (Weeks 9-10)
- **Performance Tuning**: Ensure launch < 2s and order save < 200ms.
- **Testing**: Conduct thorough manual testing and fix bugs.
- **Deployment**: Finalize the APK for production.
