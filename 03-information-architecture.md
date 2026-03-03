# Information Architecture
Project: APLI BHAJI
Date: 2026-03-03

This document outlines the high-level information architecture and user navigation flow for the APLI BHAJI application.

## Navigation Flow

The primary user journey for creating an order is designed to be linear and intuitive, following these steps:

1.  **Home Screen**
    *   The entry point of the app.
    *   Provides access to the main sections, including `Areas`.

2.  **Areas List Screen**
    *   Displays all created business areas.
    *   User selects an area to manage its customers.
    *   From here, a user can also add a new area.

3.  **Customers List Screen**
    *   Displays all customers within the selected area.
    *   User selects a customer to view their details or create an order.
    *   From here, a user can also add a new customer to the current area.

4.  **Customer Detail Screen**
    *   Shows comprehensive details of the selected customer, including their order history.
    *   Primary action is to `Create a New Order`.

5.  **Create Order Screen**
    *   The user adds items (vegetables or medicines) to the order.
    *   The system calculates the total in real-time.
    *   The user can apply discounts.

6.  **Save and View Order**
    *   Once the order is finalized, it is saved.
    *   The user is then taken to a summary or detail view of the newly created order.

7.  **Generate and Share PDF**
    *   From the order detail view, the user can generate a PDF invoice.
    *   The user is then prompted to share the PDF via external apps like WhatsApp or Telegram.

## Sitemap

-   **Home**
    -   Areas
        -   [Area Name]
            -   Customers
                -   [Customer Name]
                    -   Customer Details
                    -   Order History
                    -   Create Order
                        -   Add Items
                        -   Save Order
                        -   Generate PDF
                        -   Share
    -   Item Management
        -   Vegetables
        -   Medicines
    -   Reports
    -   Settings
        -   Backup & Restore
