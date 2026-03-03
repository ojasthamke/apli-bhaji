# User Stories and Acceptance Criteria
Project: APLI BHAJI
Date: 2026-03-03

This document outlines the user stories and their acceptance criteria based on the core modules defined in the PRD.

---

### 1. Area Management
- **As a user, I want to add, view, update, and delete business areas so I can organize my customers.**
  - **Acceptance Criteria:**
    - The user can create a new area with a name, number, and photo.
    - The app displays a list of all created areas.
    - The user can select an area to view its details.
    - The user can edit the details of an existing area.
    - The user can delete an area, which also handles associated customers appropriately.

---

### 2. Customer Management
- **As a user, I want to manage customer information within specific areas so I can track their orders and details.**
  - **Acceptance Criteria:**
    - The user can add a new customer to a selected area, including details like name, phone, address, and photo.
    - The app lists all customers belonging to a selected area.
    - The user can view detailed information for a specific customer.
    - The user can update a customer's information.
    - The user can delete a customer.

---

### 3. Item Management
- **As a user, I want to manage the items I sell, with a distinction between vegetables and medicines.**
  - **Acceptance Criteria:**
    - The user can add a new item with a name, category (vegetable/medicine), price, MRP, and unit.
    - A toggle allows the user to switch between viewing/adding vegetables or medicines.
    - The app lists all available items.
    - The user can enable or disable an item to control its visibility during order creation.

---

### 4. Order & Billing
- **As a user, I want to create and manage orders for my customers efficiently.**
  - **Acceptance Criteria:**
    - The user can select a customer and start creating a new order.
    - The user can add items from the item list to the order.
    - The app automatically calculates the total amount as items are added.
    - The user can apply a discount to the order.
    - The app saves the order to the customer's history.
    - The system must be fast, saving an order in under 200ms.

---

### 5. PDF Invoice and Sharing
- **As a user, I want to generate and share professional invoices with my customers.**
  - **Acceptance Criteria:**
    - The app can generate a clean, professional PDF invoice for any saved order.
    - The invoice includes business details, customer details, itemized list, and final amount.
    - The user can share the generated PDF through WhatsApp or Telegram with a single tap.

---

### 6. Backup & Restore
- **As a user, I want to secure my data by creating backups and be able to restore it.**
  - **Acceptance Criteria:**
    - The user can trigger a full backup of the application data (database).
    - The backup is saved as a single file (e.g., JSON) that the user can store externally.
    - The user can select a backup file to restore the app's data.
    - The restore process warns the user that it will overwrite existing data.

---

### 7. Reports
- **As a user, I want to view reports to understand my business performance.**
  - **Acceptance Criteria:**
    - The app provides simple reports (e.g., total sales, customer balances).
    - Reports can be filtered by date or customer.
