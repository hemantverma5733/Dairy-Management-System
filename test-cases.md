# Order + Payment + Subscription Test Cases

| ID | Module | Test | Expected result |
|---|---|---|---|
| ORD-01 | Order | Place order with active product and quantity within stock | Order, item, stock reduction and inventory entry are committed |
| ORD-02 | Order | Quantity = 0 or negative | Request rejected; no database changes |
| ORD-03 | Order | Quantity greater than stock | Request rejected; stock unchanged |
| ORD-04 | Order | Inactive/nonexistent product | Request rejected; no order created |
| ORD-05 | Order | Database failure during order transaction | Order transaction rolls back |
| PAY-01 | Payment | Receive full amount for valid order | Payment saved; order becomes PAID |
| PAY-02 | Payment | Receive amount less than balance | Payment saved; order becomes PARTIAL |
| PAY-03 | Payment | Receive amount greater than balance | Payment rejected; no payment/status change |
| PAY-04 | Payment | Order belongs to another customer | Payment rejected |
| PAY-05 | Payment | Standalone customer payment without order | Payment saved with NULL order_id |
| SUB-01 | Subscription | Create active subscription | Subscription saved |
| SUB-02 | Subscription | Quantity <= 0 | Request rejected |
| SUB-03 | Subscription | End date before start date | Request rejected |
| SUB-04 | Subscription | Blank end date | Open-ended subscription saved |
| SUB-05 | Subscription | Update existing subscription | Existing row updated |
| SUB-06 | Subscription | Delete subscription | Selected row deleted |
