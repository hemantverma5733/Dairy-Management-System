# Mantra — Customer Management Module

## Scope
Customer JSP/forms/search/dashboard plus Customer Entity, Repository, Service and Controllers.

## Architecture
Browser/JSP -> CustomerServlet / CustomerUpdateServlet / CustomerDeleteServlet / CustomerDashboardServlet -> CustomerService -> CustomerRepository -> MySQL.

## Features
- Add customer/buyer
- Edit customer
- Delete customer
- Search by name, mobile, address or customer type
- Customer type: RETAIL, WHOLESALER, HOTEL, RESTAURANT, OTHER
- ACTIVE/INACTIVE status
- 10-digit mobile validation
- Customer dashboard with active and total counts
- Bootstrap 5 responsive UI
- Prepared statements for database access

## Files
- entity/Customer.java
- repository/CustomerRepository.java
- service/CustomerService.java
- controller/CustomerServlet.java
- controller/CustomerUpdateServlet.java
- controller/CustomerDeleteServlet.java
- controller/CustomerDashboardServlet.java
- customer.jsp
- customer_edit.jsp
- customer_dashboard.jsp

## Testing
1. Add a valid customer and confirm it appears in the list.
2. Try a mobile number other than 10 digits; validation should reject it.
3. Search using customer name or mobile.
4. Edit customer details and verify the updated row.
5. Delete a customer and verify removal.
6. Open Customer Dashboard and verify active/total counts.
