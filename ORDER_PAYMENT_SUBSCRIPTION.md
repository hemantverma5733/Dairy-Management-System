# SmartDairy – Order, Payment & Subscription Module

## Owner
Navneet Kumar

## Scope
- Product ordering UI and order processing
- Inventory-aware stock validation and stock-out recording
- Customer payment capture and order payment status
- Recurring dairy subscriptions
- MVC-style separation: Entity → Repository → Service → Servlet Controller → JSP

## Package structure
```text
com.smartdairy
├── controller
│   ├── OrderServlet.java
│   ├── PaymentServlet.java
│   ├── SubscriptionServlet.java
│   ├── SubscriptionUpdateServlet.java
│   └── SubscriptionDeleteServlet.java
├── model
│   ├── Order.java
│   ├── OrderItem.java
│   ├── Payment.java
│   └── Subscription.java
├── repository
│   ├── OrderRepository.java
│   ├── PaymentRepository.java
│   └── SubscriptionRepository.java
└── service
    ├── OrderService.java
    ├── PaymentService.java
    └── SubscriptionService.java
```

## Order workflow
1. Customer selects an active product and quantity.
2. `OrderService` checks that the product exists and stock is sufficient.
3. Current selling price is read from the database; the browser cannot override it.
4. Order and order item are inserted in one transaction.
5. Product stock is reduced and an inventory `STOCK OUT` transaction is recorded.
6. Any failure rolls back the complete transaction.

## Payment workflow
1. Customer and optional order are selected.
2. If an order is selected, the service verifies ownership and calculates received payments.
3. Payment greater than the outstanding balance is rejected.
4. Payment is stored as `RECEIVED`.
5. Order status becomes `PARTIAL` or `PAID` automatically.
6. Database transaction protects payment and status update consistency.

## Subscription workflow
- Create, update and delete subscription records.
- Validate positive quantity and valid customer/product IDs.
- Reject an end date earlier than the start date.
- Allow an open-ended subscription by leaving end date blank.

## UI
Existing JSP pages remain the user-facing layer:
- `order.jsp` – product ordering and order list
- `payment.jsp` – payment form, payment history/status
- `subscription.jsp` – subscription form and list
- `subscription_edit.jsp` – subscription update form

## Database
Run `docs/order-payment-subscription-schema.sql` after the base `customers` and `products` tables are available.

## Security / quality notes
- SQL uses `PreparedStatement`.
- Business rules are enforced server-side, not only by HTML validation.
- Monetary values are persisted using DECIMAL columns in the supplied schema.
- No raw card PIN/password data is stored by this module.
- Controllers only parse HTTP input and delegate business logic to services.
