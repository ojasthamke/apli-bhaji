# Database Schema Document
Project: APLI BHAJI
Date: 2026-03-03

## Database Schema

### Areas
- `id` (INTEGER, PRIMARY KEY, AUTOINCREMENT)
- `name` (TEXT)
- `photoPath` (TEXT)
- `areaNumber` (TEXT)
- `createdAt` (DATETIME, DEFAULT CURRENT_TIMESTAMP)

### Customers
- `id` (INTEGER, PRIMARY KEY, AUTOINCREMENT)
- `name` (TEXT)
- `phone` (TEXT)
- `address` (TEXT)
- `houseNumber` (TEXT)
- `areaId` (INTEGER, FOREIGN KEY REFERENCES Areas(id))
- `locationLink` (TEXT)
- `photoPath` (TEXT)
- `notes` (TEXT)
- `createdAt` (DATETIME, DEFAULT CURRENT_TIMESTAMP)

### Items
- `id` (INTEGER, PRIMARY KEY, AUTOINCREMENT)
- `name` (TEXT)
- `category` (TEXT) -- e.g., 'Vegetable', 'Medicine'
- `price` (REAL)
- `mrp` (REAL)
- `unit` (TEXT) -- e.g., 'kg', 'unit'
- `isEnabled` (INTEGER, 0 or 1)
- `createdAt` (DATETIME, DEFAULT CURRENT_TIMESTAMP)

### Orders
- `id` (INTEGER, PRIMARY KEY, AUTOINCREMENT)
- `customerId` (INTEGER, FOREIGN KEY REFERENCES Customers(id))
- `totalAmount` (REAL)
- `discount` (REAL)
- `finalAmount` (REAL)
- `status` (TEXT) -- e.g., 'Pending', 'Paid'
- `dateTime` (DATETIME, DEFAULT CURRENT_TIMESTAMP)
- `updatedAt` (DATETIME, DEFAULT CURRENT_TIMESTAMP)

### OrderItems
- `id` (INTEGER, PRIMARY KEY, AUTOINCREMENT)
- `orderId` (INTEGER, FOREIGN KEY REFERENCES Orders(id))
- `itemId` (INTEGER, FOREIGN KEY REFERENCES Items(id))
- `quantity` (REAL)
- `price` (REAL)
- `mrp` (REAL)
- `total` (REAL)

## Relationships
- **Area -> Customers**: One area can have many customers.
- **Customer -> Orders**: One customer can have many orders.
- **Order -> OrderItems**: One order can have many items.