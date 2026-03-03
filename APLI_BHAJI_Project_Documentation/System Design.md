# System Design Document
Project: APLI BHAJI
Date: 2026-03-03

## Database Schema

Areas(id, name, photoPath, areaNumber, createdAt)
Customers(id, name, phone, address, houseNumber, areaId, locationLink, photoPath, notes, createdAt)
Items(id, name, category, price, mrp, unit, isEnabled, createdAt)
Orders(id, customerId, totalAmount, discount, finalAmount, status, dateTime, updatedAt)
OrderItems(id, orderId, itemId, quantity, price, mrp, total)

## Relationships
- Area → Customers
- Customer → Orders
- Order → OrderItems

## Order Save Logic
- Begin transaction
- Insert order
- Insert order items
- Commit transaction

## Backup Strategy
- Export full DB to JSON
- Import overwrites existing DB after backup