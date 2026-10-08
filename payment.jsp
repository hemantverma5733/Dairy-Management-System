<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Payments - Smart Dairy</title>

<style>

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f4f7fb;
}

.header {
    background: #263238;
    color: white;
    padding: 18px 30px;
    font-size: 24px;
    font-weight: bold;
}

.container {
    width: 92%;
    margin: 25px auto;
}

.card {
    background: white;
    padding: 25px;
    border-radius: 10px;
    box-shadow: 0 3px 12px rgba(0,0,0,0.08);
    margin-bottom: 25px;
}

h2 {
    margin-top: 0;
    color: #263238;
}

.form-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 15px;
}

label {
    font-weight: bold;
    margin-bottom: 6px;
    display: block;
}

input,
select,
textarea {
    width: 100%;
    padding: 10px;
    box-sizing: border-box;
    border: 1px solid #ccc;
    border-radius: 6px;
}

textarea {
    resize: vertical;
}

button {
    background: #263238;
    color: white;
    border: none;
    padding: 11px 22px;
    border-radius: 6px;
    cursor: pointer;
    margin-top: 22px;
}

button:hover {
    background: #37474f;
}

.success {
    background: #d4edda;
    color: #155724;
    padding: 12px;
    border-radius: 6px;
    margin-bottom: 15px;
}

.error {
    background: #f8d7da;
    color: #721c24;
    padding: 12px;
    border-radius: 6px;
    margin-bottom: 15px;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
}

th {
    background: #263238;
    color: white;
    padding: 12px;
}

td {
    padding: 11px;
    border-bottom: 1px solid #ddd;
    text-align: center;
}

tr:hover {
    background: #f5f5f5;
}

.paid {
    color: green;
    font-weight: bold;
}

.received {
    color: green;
    font-weight: bold;
}

</style>

</head>

<body>


<div class="header">
    Smart Dairy - Payments & Customer Ledger
</div>


<div class="container">


<%
    String success = request.getParameter("success");
    String error = request.getParameter("error");

    if ("true".equals(success)) {
%>

<div class="success">
    Payment received successfully.
</div>

<%
    }

    if ("amount".equals(error)) {
%>

<div class="error">
    Payment amount must be greater than zero.
</div>

<%
    }

    if ("order".equals(error)) {
%>

<div class="error">
    Selected order was not found for this customer.
</div>

<%
    }

    if ("excess".equals(error)) {
%>

<div class="error">
    Payment cannot be greater than the pending order amount.
</div>

<%
    }

    if ("true".equals(error)) {
%>

<div class="error">
    Error while saving payment.
</div>

<%
    }
%>


<!-- ADD PAYMENT -->

<div class="card">

<h2>Receive Payment</h2>


<form action="PaymentServlet" method="post">


<div class="form-grid">


<!-- CUSTOMER -->

<div>

<label>Customer</label>

<select name="customer_id" required>

<option value="">
    Select Customer
</option>

<%

Connection customerCon = null;
PreparedStatement customerPs = null;
ResultSet customerRs = null;

try {

    customerCon =
        DBConnection.getConnection();

    String customerSql =
        "SELECT id, name, mobile "
        + "FROM customers "
        + "WHERE status = 'ACTIVE' "
        + "ORDER BY name";

    customerPs =
        customerCon.prepareStatement(
            customerSql
        );

    customerRs =
        customerPs.executeQuery();

    while (customerRs.next()) {

%>

<option value="<%= customerRs.getInt("id") %>">

<%= customerRs.getString("name") %>
-
<%= customerRs.getString("mobile") %>

</option>

<%

    }

} catch (Exception e) {

    out.println(
        "<option>Error loading customers</option>"
    );

} finally {

    try {
        if (customerRs != null) customerRs.close();
    } catch (Exception e) {}

    try {
        if (customerPs != null) customerPs.close();
    } catch (Exception e) {}

    try {
        if (customerCon != null) customerCon.close();
    } catch (Exception e) {}

}

%>

</select>

</div>


<!-- ORDER ID -->

<div>

<label>Order ID</label>

<select name="order_id">

<option value="">
    Select Order
</option>

<%

Connection orderCon = null;
PreparedStatement orderPs = null;
ResultSet orderRs = null;

try {

    orderCon =
        DBConnection.getConnection();

    String orderSql =
        "SELECT o.id, o.total_amount, "
        + "c.name AS customer_name, "
        + "o.payment_status "
        + "FROM orders o "
        + "JOIN customers c "
        + "ON o.customer_id = c.id "
        + "WHERE o.payment_status <> 'PAID' "
        + "ORDER BY o.id DESC";

    orderPs =
        orderCon.prepareStatement(
            orderSql
        );

    orderRs =
        orderPs.executeQuery();

    while (orderRs.next()) {

%>

<option value="<%= orderRs.getInt("id") %>">

Order #<%= orderRs.getInt("id") %>
-
<%= orderRs.getString("customer_name") %>
-
Rs. <%= orderRs.getDouble("total_amount") %>
-
<%= orderRs.getString("payment_status") %>

</option>

<%

    }

} catch (Exception e) {

    out.println(
        "<option>Error loading orders</option>"
    );

} finally {

    try {
        if (orderRs != null) orderRs.close();
    } catch (Exception e) {}

    try {
        if (orderPs != null) orderPs.close();
    } catch (Exception e) {}

    try {
        if (orderCon != null) orderCon.close();
    } catch (Exception e) {}

}

%>

</select>

</div>


<!-- DATE -->

<div>

<label>Payment Date</label>

<input type="date"
       name="payment_date"
       id="payment_date"
       required>

</div>


<!-- AMOUNT -->

<div>

<label>Payment Amount</label>

<input type="number"
       name="amount"
       step="0.01"
       min="0.01"
       placeholder="Enter amount"
       required>

</div>


<!-- METHOD -->

<div>

<label>Payment Method</label>

<select name="payment_method" required>

<option value="">
    Select Method
</option>

<option value="CASH">
    CASH
</option>

<option value="UPI">
    UPI
</option>

<option value="BANK">
    BANK
</option>

<option value="OTHER">
    OTHER
</option>

</select>

</div>


<!-- TRANSACTION REFERENCE -->

<div>

<label>Transaction Reference</label>

<input type="text"
       name="transaction_reference"
       placeholder="UPI/Bank reference">

</div>


<!-- REMARKS -->

<div style="grid-column: span 2;">

<label>Remarks</label>

<textarea name="remarks"
          rows="3"
          placeholder="Enter payment remarks"></textarea>

</div>


</div>


<button type="submit">
    Receive Payment
</button>


</form>

</div>


<!-- PAYMENT HISTORY -->

<div class="card">

<h2>Payment History</h2>


<table>


<tr>

<th>Payment ID</th>

<th>Customer</th>

<th>Order ID</th>

<th>Date</th>

<th>Amount</th>

<th>Method</th>

<th>Status</th>

<th>Reference</th>

<th>Remarks</th>

</tr>


<%

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {

    con =
        DBConnection.getConnection();

    String sql =
        "SELECT p.id, "
        + "c.name AS customer_name, "
        + "p.order_id, "
        + "p.payment_date, "
        + "p.amount, "
        + "p.payment_method, "
        + "p.payment_status, "
        + "p.transaction_reference, "
        + "p.remarks "
        + "FROM payments p "
        + "JOIN customers c "
        + "ON p.customer_id = c.id "
        + "ORDER BY p.id DESC";

    ps =
        con.prepareStatement(sql);

    rs =
        ps.executeQuery();


    while (rs.next()) {

%>


<tr>


<td>
    <%= rs.getInt("id") %>
</td>


<td>
    <%= rs.getString("customer_name") %>
</td>


<td>

<%
    if (rs.getObject("order_id") == null) {
%>

-

<%
    } else {
%>

#<%= rs.getInt("order_id") %>

<%
    }
%>

</td>


<td>
    <%= rs.getDate("payment_date") %>
</td>


<td>
    Rs. <%= rs.getDouble("amount") %>
</td>


<td>
    <%= rs.getString("payment_method") %>
</td>


<td>

<span class="received">
    <%= rs.getString("payment_status") %>
</span>

</td>


<td>

<%
    String reference =
        rs.getString("transaction_reference");

    if (reference == null ||
        reference.trim().isEmpty()) {
%>

-

<%
    } else {
%>

<%= reference %>

<%
    }
%>

</td>


<td>

<%
    String remarks =
        rs.getString("remarks");

    if (remarks == null ||
        remarks.trim().isEmpty()) {
%>

-

<%
    } else {
%>

<%= remarks %>

<%
    }
%>

</td>


</tr>


<%

    }

} catch (Exception e) {

%>


<tr>

<td colspan="9">

Error loading payments:

<%= e.getMessage() %>

</td>

</tr>


<%

} finally {

    try {
        if (rs != null) rs.close();
    } catch (Exception e) {}

    try {
        if (ps != null) ps.close();
    } catch (Exception e) {}

    try {
        if (con != null) con.close();
    } catch (Exception e) {}

}

%>


</table>

</div>


</div>


<script>

// Set today's date

let today = new Date();

let year = today.getFullYear();

let month = String(
    today.getMonth() + 1
).padStart(2, '0');

let day = String(
    today.getDate()
).padStart(2, '0');

document.getElementById(
    "payment_date"
).value =
    year + "-" + month + "-" + day;

</script>


</body>

</html>