
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

<title>Inventory Management - Smart Dairy</title>

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

.stock-in {
    color: green;
    font-weight: bold;
}

.stock-out {
    color: red;
    font-weight: bold;
}

</style>

</head>

<body>


<div class="header">
    Smart Dairy - Inventory Management
</div>


<div class="container">


<%
    String success = request.getParameter("success");
    String error = request.getParameter("error");

    if ("true".equals(success)) {
%>

<div class="success">
    Inventory transaction saved successfully.
</div>

<%
    }

    if ("insufficient".equals(error)) {
%>

<div class="error">
    Stock Out quantity cannot be greater than current stock.
</div>

<%
    } else if ("true".equals(error)) {
%>

<div class="error">
    Error while saving inventory transaction.
</div>

<%
    }
%>


<!-- INVENTORY TRANSACTION -->

<div class="card">

<h2>Add Inventory Transaction</h2>


<form action="InventoryServlet" method="post">


<div class="form-grid">


<div>

<label>Product</label>

<select name="product_id" required>

<option value="">
    Select Product
</option>

<%

Connection productCon = null;
PreparedStatement productPs = null;
ResultSet productRs = null;

try {

    productCon = DBConnection.getConnection();

    String productSql =
        "SELECT id, product_name, unit, stock "
        + "FROM products "
        + "WHERE status = 'ACTIVE' "
        + "ORDER BY product_name";

    productPs =
        productCon.prepareStatement(productSql);

    productRs =
        productPs.executeQuery();

    while (productRs.next()) {

%>

<option value="<%= productRs.getInt("id") %>">

<%= productRs.getString("product_name") %>
-
<%= productRs.getDouble("stock") %>
<%= productRs.getString("unit") %>

</option>

<%

    }

} catch (Exception e) {

    out.println(
        "<option>Error loading products</option>"
    );

} finally {

    try {
        if (productRs != null) productRs.close();
    } catch (Exception e) {}

    try {
        if (productPs != null) productPs.close();
    } catch (Exception e) {}

    try {
        if (productCon != null) productCon.close();
    } catch (Exception e) {}

}

%>

</select>

</div>


<div>

<label>Transaction Type</label>

<select name="transaction_type" required>

<option value="">
    Select Type
</option>

<option value="STOCK IN">
    STOCK IN
</option>

<option value="STOCK OUT">
    STOCK OUT
</option>

</select>

</div>


<div>

<label>Quantity</label>

<input type="number"
       step="0.01"
       min="0.01"
       name="quantity"
       placeholder="Enter quantity"
       required>

</div>


<div>

<label>Transaction Date</label>

<input type="date"
       name="transaction_date"
       required>

</div>


<div>

<label>Reference Type</label>

<select name="reference_type">

<option value="">
    Select Reference
</option>

<option value="PURCHASE">
    Purchase
</option>

<option value="SALE">
    Sale
</option>

<option value="MILK COLLECTION">
    Milk Collection
</option>

<option value="ADJUSTMENT">
    Adjustment
</option>

<option value="OTHER">
    Other
</option>

</select>

</div>


<div>

<label>Reference ID</label>

<input type="number"
       name="reference_id"
       placeholder="Optional">

</div>


<div style="grid-column: span 2;">

<label>Remarks</label>

<textarea name="remarks"
          rows="3"
          placeholder="Enter remarks if required"></textarea>

</div>


</div>


<button type="submit">
    Save Transaction
</button>


</form>

</div>


<!-- INVENTORY HISTORY -->

<div class="card">

<h2>Inventory Transaction History</h2>


<table>


<tr>

<th>ID</th>

<th>Product</th>

<th>Transaction Type</th>

<th>Quantity</th>

<th>Reference Type</th>

<th>Reference ID</th>

<th>Date</th>

<th>Remarks</th>

</tr>


<%

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {

    con = DBConnection.getConnection();

    String sql =
        "SELECT i.*, p.product_name, p.unit "
        + "FROM inventory i "
        + "JOIN products p ON i.product_id = p.id "
        + "ORDER BY i.id DESC";

    ps = con.prepareStatement(sql);

    rs = ps.executeQuery();


    while (rs.next()) {

        String transactionType =
            rs.getString("transaction_type");

%>


<tr>


<td>
    <%= rs.getInt("id") %>
</td>


<td>
    <%= rs.getString("product_name") %>
</td>


<td>

<%
    if ("STOCK IN".equals(transactionType)) {
%>

<span class="stock-in">
    STOCK IN
</span>

<%
    } else {
%>

<span class="stock-out">
    STOCK OUT
</span>

<%
    }
%>

</td>


<td>
    <%= rs.getDouble("quantity") %>
    <%= rs.getString("unit") %>
</td>


<td>
    <%= rs.getString("reference_type") == null
        ? "-"
        : rs.getString("reference_type") %>
</td>


<td>
    <%= rs.getObject("reference_id") == null
        ? "-"
        : rs.getInt("reference_id") %>
</td>


<td>
    <%= rs.getDate("transaction_date") %>
</td>


<td>
    <%= rs.getString("remarks") == null
        ? "-"
        : rs.getString("remarks") %>
</td>


</tr>


<%

    }

} catch (Exception e) {

%>


<tr>

<td colspan="8">

Error loading inventory:

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


</body>

</html>
