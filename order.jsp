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

<title>Orders - Smart Dairy</title>

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

.pending {
    color: #ef6c00;
    font-weight: bold;
}

.confirmed {
    color: #1565c0;
    font-weight: bold;
}

.delivered {
    color: green;
    font-weight: bold;
}

.cancelled {
    color: red;
    font-weight: bold;
}

</style>

</head>

<body>


<div class="header">
    Smart Dairy - Orders & Sales
</div>


<div class="container">


<%
    String success = request.getParameter("success");
    String error = request.getParameter("error");

    if ("true".equals(success)) {
%>

<div class="success">
    Order placed successfully and stock has been updated.
</div>

<%
    }

    if ("stock".equals(error)) {
%>

<div class="error">
    Insufficient stock. Please check current product stock.
</div>

<%
    }

    if ("product".equals(error)) {
%>

<div class="error">
    Selected product was not found.
</div>

<%
    }

    if ("true".equals(error)) {
%>

<div class="error">
    Error while placing order.
</div>

<%
    }
%>


<!-- ADD ORDER -->

<div class="card">

<h2>Create New Order</h2>


<form action="OrderServlet" method="post">


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

    customerCon = DBConnection.getConnection();

    String customerSql =
        "SELECT id, name, mobile "
        + "FROM customers "
        + "WHERE status = 'ACTIVE' "
        + "ORDER BY name";

    customerPs =
        customerCon.prepareStatement(customerSql);

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


<!-- PRODUCT -->

<div>

<label>Product</label>

<select name="product_id"
        id="product_id"
        onchange="updatePrice()"
        required>

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
        "SELECT id, product_name, selling_price, stock, unit "
        + "FROM products "
        + "WHERE status = 'ACTIVE' "
        + "ORDER BY product_name";

    productPs =
        productCon.prepareStatement(productSql);

    productRs =
        productPs.executeQuery();

    while (productRs.next()) {

%>

<option
    value="<%= productRs.getInt("id") %>"
    data-price="<%= productRs.getDouble("selling_price") %>"
    data-stock="<%= productRs.getDouble("stock") %>"
    data-unit="<%= productRs.getString("unit") %>"
>

<%= productRs.getString("product_name") %>
-
Stock:
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


<!-- QUANTITY -->

<div>

<label>Quantity</label>

<input type="number"
       name="quantity"
       id="quantity"
       step="0.01"
       min="0.01"
       placeholder="Enter quantity"
       oninput="calculateTotal()"
       required>

</div>


<!-- DATE -->

<div>

<label>Order Date</label>

<input type="date"
       name="order_date"
       id="order_date"
       required>

</div>


<!-- PRICE -->

<div>

<label>Selling Price</label>

<input type="text"
       id="price"
       value="0.00"
       readonly>

</div>


<!-- TOTAL -->

<div>

<label>Total Amount</label>

<input type="text"
       id="total"
       value="0.00"
       readonly>

</div>


<!-- STATUS -->

<div>

<label>Order Status</label>

<select name="status">

<option value="PENDING">
    PENDING
</option>

<option value="CONFIRMED">
    CONFIRMED
</option>

<option value="OUT FOR DELIVERY">
    OUT FOR DELIVERY
</option>

<option value="DELIVERED">
    DELIVERED
</option>

</select>

</div>


<!-- PAYMENT -->

<div>

<label>Payment Status</label>

<select name="payment_status">

<option value="PENDING">
    PENDING
</option>

<option value="PAID">
    PAID
</option>

<option value="PARTIAL">
    PARTIAL
</option>

</select>

</div>


<!-- REMARKS -->

<div style="grid-column: span 4;">

<label>Remarks</label>

<textarea name="remarks"
          rows="3"
          placeholder="Enter order remarks"></textarea>

</div>


</div>


<button type="submit">
    Place Order
</button>


</form>

</div>


<!-- ORDER HISTORY -->

<div class="card">

<h2>Order History</h2>


<table>


<tr>

<th>Order ID</th>

<th>Customer</th>

<th>Date</th>

<th>Product</th>

<th>Quantity</th>

<th>Price</th>

<th>Total</th>

<th>Status</th>

<th>Payment</th>

<th>Remarks</th>

</tr>


<%

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {

    con = DBConnection.getConnection();

    String sql =
        "SELECT o.id, "
        + "c.name AS customer_name, "
        + "o.order_date, "
        + "p.product_name, "
        + "oi.quantity, "
        + "oi.price, "
        + "oi.total, "
        + "o.status, "
        + "o.payment_status, "
        + "o.remarks "
        + "FROM orders o "
        + "JOIN customers c "
        + "ON o.customer_id = c.id "
        + "JOIN order_items oi "
        + "ON o.id = oi.order_id "
        + "JOIN products p "
        + "ON oi.product_id = p.id "
        + "ORDER BY o.id DESC";

    ps = con.prepareStatement(sql);

    rs = ps.executeQuery();


    while (rs.next()) {

        String orderStatus =
            rs.getString("status");

%>


<tr>


<td>
    #<%= rs.getInt("id") %>
</td>


<td>
    <%= rs.getString("customer_name") %>
</td>


<td>
    <%= rs.getDate("order_date") %>
</td>


<td>
    <%= rs.getString("product_name") %>
</td>


<td>
    <%= rs.getDouble("quantity") %>
</td>


<td>
    Rs. <%= rs.getDouble("price") %>
</td>


<td>
    Rs. <%= rs.getDouble("total") %>
</td>


<td>

<%
    if ("DELIVERED".equalsIgnoreCase(orderStatus)) {
%>

<span class="delivered">
    DELIVERED
</span>

<%
    } else if ("CANCELLED".equalsIgnoreCase(orderStatus)) {
%>

<span class="cancelled">
    CANCELLED
</span>

<%
    } else if ("CONFIRMED".equalsIgnoreCase(orderStatus)) {
%>

<span class="confirmed">
    CONFIRMED
</span>

<%
    } else {
%>

<span class="pending">
    <%= orderStatus %>
</span>

<%
    }
%>

</td>


<td>
    <%= rs.getString("payment_status") %>
</td>


<td>

<%
    String orderRemarks =
        rs.getString("remarks");

    if (orderRemarks == null ||
        orderRemarks.trim().isEmpty()) {
%>

-

<%
    } else {
%>

<%= orderRemarks %>

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

<td colspan="10">

Error loading orders:

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

// Set today's date automatically

let today = new Date();

let year = today.getFullYear();

let month = String(today.getMonth() + 1)
    .padStart(2, '0');

let day = String(today.getDate())
    .padStart(2, '0');

document.getElementById("order_date").value =
    year + "-" + month + "-" + day;


// Update price when product changes

function updatePrice() {

    let product =
        document.getElementById("product_id");

    let selected =
        product.options[product.selectedIndex];

    let price =
        selected.getAttribute("data-price");

    if (!price) {
        price = "0";
    }

    document.getElementById("price").value =
        parseFloat(price).toFixed(2);

    calculateTotal();
}


// Calculate total

function calculateTotal() {

    let price =
        parseFloat(
            document.getElementById("price").value
        ) || 0;

    let quantity =
        parseFloat(
            document.getElementById("quantity").value
        ) || 0;

    let total =
        price * quantity;

    document.getElementById("total").value =
        total.toFixed(2);
}

</script>


</body>

</html>