# API Contracts
Project: APLI BHAJI
Date: 2026-03-03

As this application is 100% offline, there are no remote API contracts. Instead, this document defines the key internal data access object (DAO) interfaces and their expected behavior.

## Database Access Layer

### Area Service

- **`Future<List<Area>> getAreas()`**: Retrieves all created areas from the database.
- **`Future<Area> createArea(Area area)`**: Adds a new area to the database.
- **`Future<void> updateArea(Area area)`**: Updates an existing area.
- **`Future<void> deleteArea(int areaId)`**: Deletes an area and handles associated customers.

### Customer Service

- **`Future<List<Customer>> getCustomersByArea(int areaId)`**: Retrieves all customers belonging to a specific area.
- **`Future<Customer> createCustomer(Customer customer)`**: Adds a new customer.
- **`Future<void> updateCustomer(Customer customer)`**: Updates an existing customer.
- **`Future<void> deleteCustomer(int customerId)`**: Deletes a customer.

### Item Service

- **`Future<List<Item>> getItemsByCategory(String category)`**: Retrieves all items (vegetable or medicine) based on the category.
- **`Future<Item> createItem(Item item)`**: Adds a new item.
- **`Future<void> updateItem(Item item)`**: Updates an existing item.
- **`Future<void> deleteItem(int itemId)`**: Deletes an item.

### Order Service

- **`Future<List<Order>> getOrdersByCustomer(int customerId)`**: Retrieves all orders for a specific customer.
- **`Future<void> saveOrder(Order order, List<OrderItem> items)`**: Saves an order and its associated items within a single database transaction for consistency.
- **`Future<OrderDetail> getOrderDetail(int orderId)`**: Retrieves a complete order detail including its items.

## Backup and Restore Interface

- **`Future<File> exportDatabaseToJson()`**: Generates a JSON file containing the entire database's current state.
- **`Future<void> importDatabaseFromJson(File jsonFile)`**: Overwrites the existing database with the data from the provided JSON file, after performing a backup of the current state.
