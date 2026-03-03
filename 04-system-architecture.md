# Architecture Document
Project: APLI BHAJI
Date: 2026-03-03
Platform: Flutter (Android)
Type: Fully Offline Application

## Overview
APLI BHAJI is a fully offline area-based vegetable and medicine billing system built using Flutter and SQLite.

## Architecture Style
Feature-Based Modular Clean Architecture.

Layers:
- Presentation Layer (Flutter UI + Riverpod)
- Domain Layer (Business Logic)
- Data Layer (SQLite + Local Storage)

## Navigation Flow
Home -> Areas -> Customers -> Customer Detail -> Create Order -> Save -> PDF -> Share

## Performance Goals
- Launch < 2 sec
- Order save < 200ms
- 1000+ customers supported
- 10,000+ orders supported