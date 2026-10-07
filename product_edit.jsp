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

<title>Edit Product - Smart Dairy</title>

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
    width: 70%;
    margin: 35px auto;
}

.card {
    background: white;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 3px 12px rgba(0,0,0,0.08);
}

h2 {
    color: #263238;
    margin-top: 0;
}

.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 18px;
}

label {
    display: block;
    font-weight: bold;
    margin-bottom: 7px;
}

input, select {
    width: 100%;
    box-sizing: border-box;
    padding: 11px;
    border: 1px solid #ccc;
    border-radius: 6px;
}

button {
    margin-top: 25px;
    padding: 12px 25px;
    border: none;
    border-radius: 6px;
    background: #263238;
    color: white;
    cursor: pointer;
}

button:hover {
    background: #37474f;
}

.back {
    display: inline-block;
    margin-left: 10px;
    padding: 12px 25px;
    text-decoration: none;
    background: #ddd;
    color: #333;
    border-radius: 6px;
}

</style>

</head>

<body>

<div class="header">
    Smart Dairy - Edit Product
</div>

<div class="container">

<div class="card">

<h2>Edit Product</h2>

<%

String id = request.getParameter("id");

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {

    con = DBConnection.getConnection();

    String sql =
        "SELECT * FROM products WHERE id = ?";

    ps = con.prepareStatement(sql);

    ps.setInt(1, Integer.parseInt(id));

    rs = ps.executeQuery();

    if (rs.next()) {

%>

<form action="ProductUpdateServlet" method="post">

<input type="hidden"
       name="id"
       value="<%= rs.getInt("id") %>">


<div class="form-grid">

<div>

<label>Product Name</label>

<input type="text"
       name="product_name"
       value="<%= rs.getString("product_name") %>"
       required>

</div>


<div>

<label>Category</label>

<select name="category" required>

<option value="MILK"
<%= "MILK".equals(rs.getString("category")) ? "selected" : "" %>>
Milk
</option>

<option value="DAIRY PRODUCT"
<%= "DAIRY PRODUCT".equals(rs.getString("category")) ? "selected" : "" %>>
Dairy Product
</option>

<option value="CURD"
<%= "CURD".equals(rs.getString("category")) ? "selected" : "" %>>
Curd
</option>

<option value="PANEER"
<%= "PANEER".equals(rs.getString("category")) ? "selected" : "" %>>
Paneer
</option>

<option value="GHEE"
<%= "GHEE".equals(rs.getString("category")) ? "selected" : "" %>>
Ghee
</option>

<option value="OTHER"
<%= "OTHER".equals(rs.getString("category")) ? "selected" : "" %>>
Other
</option>

</select>

</div>


<div>

<label>Unit</label>

<select name="unit" required>

<option value="Litre"
<%= "Litre".equals(rs.getString("unit")) ? "selected" : "" %>>
Litre
</option>

<option value="Kg"
<%= "Kg".equals(rs.getString("unit")) ? "selected" : "" %>>
Kg
</option>

<option value="Piece"
<%= "Piece".equals(rs.getString("unit")) ? "selected" : "" %>>
Piece
</option>

<option value="Packet"
<%= "Packet".equals(rs.getString("unit")) ? "selected" : "" %>>
Packet
</option>

</select>

</div>


<div>

<label>Purchase Price</label>

<input type="number"
       step="0.01"
       name="purchase_price"
       value="<%= rs.getDouble("purchase_price") %>">

</div>


<div>

<label>Selling Price</label>

<input type="number"
       step="0.01"
       name="selling_price"
       value="<%= rs.getDouble("selling_price") %>"
       required>

</div>


<div>

<label>Current Stock</label>

<input type="number"
       step="0.01"
       name="stock"
       value="<%= rs.getDouble("stock") %>">

</div>


<div>

<label>Minimum Stock</label>

<input type="number"
       step="0.01"
       name="minimum_stock"
       value="<%= rs.getDouble("minimum_stock") %>">

</div>


<div>

<label>Status</label>

<select name="status">

<option value="ACTIVE"
<%= "ACTIVE".equals(rs.getString("status")) ? "selected" : "" %>>
ACTIVE
</option>

<option value="INACTIVE"
<%= "INACTIVE".equals(rs.getString("status")) ? "selected" : "" %>>
INACTIVE
</option>

</select>

</div>

</div>


<button type="submit">
    Update Product
</button>

<a href="product.jsp" class="back">
    Back
</a>

</form>

<%

    } else {

        out.println("<h3>Product not found.</h3>");

    }

} catch (Exception e) {

    out.println(
        "<h3>Error: " + e.getMessage() + "</h3>"
    );

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

</div>

</div>

</body>

</html>