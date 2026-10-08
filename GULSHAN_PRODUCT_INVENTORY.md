# Gulshan — Product + Inventory Module

## Responsibility
- Product management UI
- Inventory transaction UI
- Product and Inventory entities
- Repository layer for database access
- Service layer for validation and business logic
- Servlet controllers for request handling
- Bootstrap 5 responsive UI

## Architecture
`JSP/UI -> Servlet Controller -> Service -> Repository -> MySQL`

### Product
- `Product.java`
- `ProductRepository.java`
- `ProductService.java`
- `ProductServlet.java`
- `ProductUpdateServlet.java`
- `ProductDeleteServlet.java`
- `product.jsp`

### Inventory
- `InventoryTransaction.java`
- `InventoryRepository.java`
- `InventoryService.java`
- `InventoryServlet.java`
- `inventory.jsp`

## Main features
1. Add, edit and delete products.
2. Product validation for name, prices and stock values.
3. Product search in the Bootstrap table.
4. Low-stock highlighting using minimum-stock threshold.
5. Record STOCK IN and STOCK OUT transactions.
6. Prevent negative stock.
7. Automatically update product stock after a transaction.
8. Use a database transaction for inventory entry + stock update.
9. Show inventory transaction history with product names.
10. Responsive Bootstrap UI.

## Integration
Existing servlet URL mappings are preserved. Dashboard Product/Inventory links now point to their controllers so the JSPs receive their required data through the MVC flow.

## Database
The module expects the existing `products` and `inventory` tables with these fields:
- products: `id, product_name, category, unit, purchase_price, selling_price, stock, minimum_stock, status`
- inventory: `id, product_id, transaction_type, quantity, reference_type, reference_id, transaction_date, remarks`

Use the project's existing MySQL configuration in `DBConnection.java`.
