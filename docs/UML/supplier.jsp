```jsp
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Smart Dairy - Suppliers</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f8;
        }

        .header {
            background: #2c3e50;
            color: white;
            padding: 20px 30px;
            font-size: 25px;
            font-weight: bold;
        }

        .container {
            width: 95%;
            margin: 25px auto;
        }

        .card {
            background: white;
            padding: 25px;
            margin-bottom: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        h2 {
            margin-top: 0;
            color: #2c3e50;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        input, select {
            width: 100%;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
        }

        button {
            background: #27ae60;
            color: white;
            border: none;
            padding: 11px 22px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
        }

        button:hover {
            opacity: 0.9;
        }

        .search-box {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .search-box input {
            flex: 1;
        }

        .search-btn {
            background: #3498db;
        }

        .clear-btn {
            background: #7f8c8d;
            text-decoration: none;
            color: white;
            padding: 11px 20px;
            border-radius: 6px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th {
            background: #34495e;
            color: white;
            padding: 12px;
        }

        td {
            padding: 11px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .edit-btn {
            background: #f39c12;
            color: white;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 5px;
        }

        .delete-btn {
            background: #e74c3c;
            color: white;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 5px;
        }

        .message {
            padding: 12px;
            margin-bottom: 15px;
            border-radius: 6px;
            background: #d4edda;
            color: #155724;
        }

        .error {
            background: #f8d7da;
            color: #721c24;
        }

        @media(max-width: 800px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            table {
                font-size: 12px;
            }
        }
    </style>
</head>

<body>

<div class="header">
    Smart Dairy - Supplier / Farmer Management
</div>

<div class="container">

    <!-- Success / Error Messages -->

    <% if ("true".equals(request.getParameter("success"))) { %>
        <div class="message">
            Supplier added successfully!
        </div>
    <% } %>

    <% if ("true".equals(request.getParameter("deleted"))) { %>
        <div class="message">
            Supplier deleted successfully!
        </div>
    <% } %>

    <% if ("true".equals(request.getParameter("updated"))) { %>
        <div class="message">
            Supplier updated successfully!
        </div>
    <% } %>

    <% if ("true".equals(request.getParameter("error"))) { %>
        <div class="message error">
            Something went wrong. Please try again.
        </div>
    <% } %>


    <!-- ADD SUPPLIER -->

    <div class="card">

        <h2>Add Supplier / Farmer</h2>

        <form action="SupplierServlet" method="post">

            <div class="form-grid">

                <div>
                    <label>Name</label>
                    <input type="text"
                           name="name"
                           placeholder="Enter supplier name"
                           required>
                </div>

                <div>
                    <label>Mobile</label>
                    <input type="text"
                           name="mobile"
                           placeholder="Enter mobile number"
                           required>
                </div>

                <div>
                    <label>Address</label>
                    <input type="text"
                           name="address"
                           placeholder="Enter address">
                </div>

                <div>
                    <label>Animal Type</label>
                    <select name="animal_type">
                        <option value="Cow">Cow</option>
                        <option value="Buffalo">Buffalo</option>
                        <option value="Both">Both</option>
                    </select>
                </div>

                <div>
                    <label>Bank Details</label>
                    <input type="text"
                           name="bank_details"
                           placeholder="Account / UPI details">
                </div>

                <div>
                    <label>Status</label>
                    <select name="status">
                        <option value="ACTIVE">ACTIVE</option>
                        <option value="INACTIVE">INACTIVE</option>
                    </select>
                </div>

            </div>

            <br>

            <button type="submit">
                Add Supplier
            </button>

        </form>

    </div>


    <!-- SUPPLIER LIST -->

    <div class="card">

        <h2>Supplier / Farmer List</h2>

        <!-- SEARCH -->

        <form method="get" action="supplier.jsp">

            <div class="search-box">

                <input type="text"
                       name="search"
                       value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>"
                       placeholder="Search by name or mobile">

                <button type="submit" class="search-btn">
                    Search
                </button>

                <a href="supplier.jsp" class="clear-btn">
                    Clear
                </a>

            </div>

        </form>


        <!-- TABLE -->

        <table>

            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Mobile</th>
                <th>Address</th>
                <th>Animal Type</th>
                <th>Bank Details</th>
                <th>Status</th>
                <th>Action</th>
            </tr>

            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {

                    con = DBConnection.getConnection();

                    String search = request.getParameter("search");

                    if (search != null && !search.trim().isEmpty()) {

                        ps = con.prepareStatement(
                            "SELECT * FROM suppliers " +
                            "WHERE name LIKE ? OR mobile LIKE ? " +
                            "ORDER BY id DESC"
                        );

                        ps.setString(1, "%" + search.trim() + "%");
                        ps.setString(2, "%" + search.trim() + "%");

                    } else {

                        ps = con.prepareStatement(
                            "SELECT * FROM suppliers ORDER BY id DESC"
                        );
                    }

                    rs = ps.executeQuery();

                    while (rs.next()) {
            %>

            <tr>

                <td><%= rs.getInt("id") %></td>

                <td><%= rs.getString("name") %></td>

                <td><%= rs.getString("mobile") %></td>

                <td><%= rs.getString("address") %></td>

                <td><%= rs.getString("animal_type") %></td>

                <td><%= rs.getString("bank_details") %></td>

                <td><%= rs.getString("status") %></td>

                <td>

                    <a class="edit-btn"
                       href="supplier_edit.jsp?id=<%= rs.getInt("id") %>">
                        Edit
                    </a>

                    &nbsp;

                    <a class="delete-btn"
                       href="SupplierDeleteServlet?id=<%= rs.getInt("id") %>"
                       onclick="return confirm('Are you sure you want to delete this supplier?');">
                        Delete
                    </a>

                </td>

            </tr>

            <%
                    }

                } catch (Exception e) {

                    out.println(
                        "<tr><td colspan='8'>Error: "
                        + e.getMessage()
                        + "</td></tr>"
                    );

                } finally {

                    try {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (con != null) con.close();
                    } catch (Exception e) {
                    }
                }
            %>

        </table>

    </div>

</div>

</body>
</html>
