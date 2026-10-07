# Weekly PBL Report – Navneet Kumar

## Module
Orders + Payment + Subscription

## Work Completed
Implemented the assigned SmartDairy module for product ordering, customer payments and recurring subscriptions. Refactored the existing servlet logic into separate Entity, Repository and Service layers. Added server-side validation for product availability, stock limits, payment outstanding balance and subscription date ranges. Added transactional order processing so order creation, stock reduction and inventory stock-out records succeed or roll back together. Payment processing now updates order payment status to PARTIAL or PAID based on the received amount. Subscription create, update and delete operations were connected to the service/repository layer. Prepared the database schema and module test cases for integration.

## Problems Faced
The initial project had most database operations directly inside servlet controllers and did not contain a dedicated model/repository/service layer for the assigned module. The existing Eclipse project also depends on the configured Tomcat runtime for Jakarta Servlet APIs, so final runtime verification must be performed in the team's Eclipse/Tomcat environment.

## Plan for Next Week
Integrate the module with the team's remaining modules, verify the MySQL schema against the shared database, test complete order-to-payment-to-delivery flows, fix integration issues, and prepare screenshots/demo evidence for the PBL review.
