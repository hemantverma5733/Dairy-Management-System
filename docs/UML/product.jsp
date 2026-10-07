
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

<title>Product Management - Smart Dairy</title>

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
select {
    width: 100%;
    padding: 10px;
    box-sizing: border-box;
    border: 1px solid #ccc;
    border-radius: 6px;
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

.search-box {
    margin-bottom: 20px;
}

.search-box input {
    width: 300px;
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

.active {
    color: green;
    font-weight: bold;
}

.inactive {
    color: red;
    font-weight: bold;
}

.low-stock {
    color: red;
    font-weight: bold;
}

.normal-stock {
    color: green;
    font-weight: bold;
}

.action-edit {
    text-decoration: none;
    color: #1565c0;
    font-weight: bold;
}

.action-delete {
    text-decoration: none;
    color: red;
    font-weight: bold;
}

</style>

</head>

<body>


<div class="header">
    Smart Dairy - Product Management
</div>


<div class="container">


<%
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    String updated = request.getParameter("updated");
    String deleted = request.getParameter("deleted");

    if ("true".equals(success)) {
%>

<div class="success">
    Product added successfully.
</div>

<%
    }

    if ("true".equals(updated)) {
%>

<div class="success">
    Product updated successfully.
</div>

<%
    }

    if ("true".equals(deleted)) {
%>

<div class="success">
    Product deleted successfully.
</div>

<%
    }

    if ("true".equals(error)) {
%>

<div class="error">
    Error while processing product.
</div>

<%
    }
%>


<!-- ADD PRODUCT -->

<div class="card">

<h2>Add New Product</h2>


<form action="ProductServlet" method="post">


<div class="form-grid">


<div>

<label>Product Name</label>

<input type="text"
       name="product_name"
       placeholder="Example: Cow Milk"
       required>

</div>


<div>

<label>Category</label>

<select name="category" required>

<option value="">
    Select Category
</option>

<option value="MILK">
    Milk
</option>

<option value="DAIRY PRODUCT">
    Dairy Product
</option>

<option value="CURD">
    Curd
</option>

<option value="PANEER">
    Paneer
</option>

<option value="GHEE">
    Ghee
</option>

<option value="OTHER">
    Other
</option>

</select>

</div>


<div>

<label>Unit</label>

<select name="unit" required>

<option value="">
    Select Unit
</option>

<option value="Litre">
    Litre
</option>

<option value="Kg">
    Kg
</option>

<option value="Piece">
    Piece
</option>

<option value="Packet">
    Packet
</option>

</select>

</div>


<div>

<label>Purchase Price</label>

<input type="number"
       step="0.01"
       name="purchase_price"
       placeholder="0">

</div>


<div>

<label>Selling Price</label>

<input type="number"
       step="0.01"
       name="selling_price"
       placeholder="Example: 60"
       required>

</div>


<div>

<label>Current Stock</label>

<input type="number"
       step="0.01"
       name="stock"
       placeholder="0">

</div>


<div>

<label>Minimum Stock</label>

<input type="number"
       step="0.01"
       name="minimum_stock"
       placeholder="Example: 20">

</div>


<div>

<label>Status</label>

<select name="status">

<option value="ACTIVE">
    ACTIVE
</option>

<option value="INACTIVE">
    INACTIVE
</option>

</select>

</div>


</div>


<button type="submit">
    Add Product
</button>


</form>

</div>


<!-- PRODUCT LIST -->

<div class="card">

<h2>Product List</h2>


<div class="search-box">

<input type="text"
       id="searchInput"
       placeholder="Search product..."
       onkeyup="searchProducts()">

</div>


<table id="productTable">


<tr>

<th>ID</th>

<th>Product Name</th>

<th>Category</th>

<th>Unit</th>

<th>Purchase Price</th>

<th>Selling Price</th>

<th>Stock</th>

<th>Minimum Stock</th>

<th>Status</th>

<th>Action</th>

</tr>


<%

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {

    con = DBConnection.getConnection();

    String sql =
        "SELECT * FROM products ORDER BY id DESC";

    ps = con.prepareStatement(sql);

    rs = ps.executeQuery();


    while (rs.next()) {

        double stock =
            rs.getDouble("stock");

        double minimumStock =
            rs.getDouble("minimum_stock");

%>


<tr>


<td>
    <%= rs.getInt("id") %>
</td>


<td>
    <%= rs.getString("product_name") %>
</td>


<td>
    <%= rs.getString("category") %>
</td>


<td>
    <%= rs.getString("unit") %>
</td>


<td>
    Rs. <%= rs.getDouble("purchase_price") %>
</td>


<td>
    Rs. <%= rs.getDouble("selling_price") %>
</td>


<td class="<%= stock <= minimumStock ? "low-stock" : "normal-stock" %>">

    <%= stock %>

    <% if (stock <= minimumStock) { %>

        <br>
        <span>LOW STOCK</span>

    <% } %>

</td>


<td>
    <%= minimumStock %>
</td>


<td>

<%
    String statusValue =
        rs.getString("status");

    if ("ACTIVE".equalsIgnoreCase(statusValue)) {
%>

<span class="active">
    ACTIVE
</span>

<%
    } else {
%>

<span class="inactive">
    INACTIVE
</span>

<%
    }
%>

</td>


<td>

<a class="action-edit"
   href="product_edit.jsp?id=<%= rs.getInt("id") %>">

    Edit

</a>

&nbsp; | &nbsp;

<a class="action-delete"
   href="ProductDeleteServlet?id=<%= rs.getInt("id") %>"
   onclick="return confirm('Are you sure you want to delete this product?');">

    Delete

</a>

</td>


</tr>


<%

    }

} catch (Exception e) {

%>


<tr>

<td colspan="10">

Error loading products:

<%= e.getMessage() %>

</td>

</tr>


<%

} finally {

    try {

        if (rs != null) {
            rs.close();
        }

    } catch (Exception e) {}


    try {

        if (ps != null) {
            ps.close();
        }

    } catch (Exception e) {}


    try {

        if (con != null) {
            con.close();
        }

    } catch (Exception e) {}

}

%>


</table>

</div>


</div>


<script>

function searchProducts() {

    let input =
        document.getElementById("searchInput")
        .value.toLowerCase();

    let table =
        document.getElementById("productTable");

    let rows =
        table.getElementsByTagName("tr");


    for (let i = 1; i < rows.length; i++) {

        let text =
            rows[i].innerText.toLowerCase();

        if (text.includes(input)) {

            rows[i].style.display = "";

        } else {

            rows[i].style.display = "none";

        }

    }

}

</script>


</body>

</html>