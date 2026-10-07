# Hemant Module — Distributor, Delivery, Reports & Expenses

## Scope
- Distributor management
- Delivery scheduling/status
- Expense management
- Dashboard/report summaries
- JSP UI pages with Bootstrap 5 CDN support

## Architecture
`JSP -> Controller -> Service -> Repository -> DBConnection/MySQL`

Entities: `Distributor`, `Delivery`, `Expense`, `ReportSummary`.

Repositories: `DistributorRepository`, `DeliveryRepository`, `ExpenseRepository`, `ReportRepository`.

Services: `DistributorService`, `DeliveryService`, `ExpenseService`, `ReportService`.

Controllers: `DistributorController`, `DeliveryController`, `ExpenseController`, `ReportController`.

## Existing URLs preserved
The original `DistributorServlet`, `DeliveryServlet`, and `ExpenseServlet` remain in the project so the existing pages continue to work. The new controllers provide the layered backend for Hemant's module. `WEB-INF/hemant-module-web.xml` contains the servlet mappings to merge into the deployment descriptor if annotation-free mapping is preferred.

## Database tables used
- `distributors`
- `deliveries`
- `expenses`
- `orders`, `milk_collection`, `payments`, `invoices` for report summaries

## Validation
- Distributor name required.
- Delivery requires a valid order ID and delivery person.
- Expense date required and amount must be greater than zero.
- Prepared statements are used throughout repository/database operations.
