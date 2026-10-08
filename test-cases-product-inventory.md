# Product + Inventory Test Cases

| ID | Test | Expected Result |
|---|---|---|
| P01 | Add valid product | Product is saved and appears in list |
| P02 | Add product with blank name | Validation error |
| P03 | Add negative price/stock | Validation error |
| P04 | Edit existing product | Updated values are displayed |
| P05 | Delete product | Product is removed if no dependent record blocks deletion |
| I01 | STOCK IN | Inventory record created and stock increases |
| I02 | STOCK OUT within available stock | Inventory record created and stock decreases |
| I03 | STOCK OUT above available stock | Transaction rejected; stock unchanged |
| I04 | Zero/negative quantity | Transaction rejected |
| I05 | Refresh inventory page | Product list and transaction history load through controller |
