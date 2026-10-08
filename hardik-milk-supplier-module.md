# Hardik — Supplier + Milk Collection Module

## Scope
Supplier management and daily milk collection with calculated collection amount.

## Architecture
Entity → Repository → Service → Controller → JSP

## Supplier
- Add, update and delete suppliers.
- Validate name, 10-digit mobile number and status.
- Search by supplier name, mobile or animal type.

## Milk Collection
- Capture date, supplier, shift, animal type, quantity, fat, SNF and rate.
- Validate positive quantity, non-negative rate/fat/SNF, valid shift and non-future collection date.
- Calculate amount automatically: `amount = quantity × rate`.
- Store the calculated amount in `milk_collection`.
- Dashboard/records service provides total quantity, total amount and entry count.

## Existing URLs preserved
- `SupplierServlet`
- `SupplierUpdateServlet`
- `SupplierDeleteServlet`
- `MilkCollectionServlet`

## Additional controller
- `MilkRecordsServlet` prepares recent collection records and summary values.

## Note
Run the project's MySQL schema before browser testing. Full integration testing requires the configured local MySQL database and Tomcat runtime.
