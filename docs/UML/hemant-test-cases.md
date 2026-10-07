# Hemant Module Test Cases

| ID | Module | Test | Expected |
|---|---|---|---|
| H-01 | Distributor | Add distributor with name/status | Record saved |
| H-02 | Distributor | Submit blank name | Validation/error response |
| H-03 | Distributor | Update distributor | Existing record updated |
| H-04 | Distributor | Delete distributor | Record removed |
| H-05 | Delivery | Add delivery for valid order | Delivery saved |
| H-06 | Delivery | Invalid/missing order ID | Request rejected |
| H-07 | Delivery | Update delivery status | Status changes |
| H-08 | Delivery | Delete delivery | Record removed |
| H-09 | Expense | Add positive expense | Record saved |
| H-10 | Expense | Amount <= 0 | Validation/error response |
| H-11 | Expense | Filter expense report by dates | Matching records shown |
| H-12 | Reports | Open report dashboard | Summary metrics load |
| H-13 | Reports | Verify today's expense total | Matches database aggregate |
| H-14 | Reports | Verify monthly sales/expense | Matches month aggregate |
