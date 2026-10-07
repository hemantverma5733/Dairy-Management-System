<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Smart Dairy - Distributor Management</title>

    <style>

        * {
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            margin: 0;
            background: #f4f6f9;
        }

        .header {
            background: #6a1b9a;
            color: white;
            padding: 20px 35px;
            font-size: 25px;
            font-weight: bold;
        }

        .container {
            width: 94%;
            margin: 30px auto;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            margin-bottom: 25px;
        }

        h2 {
            margin-top: 0;
            color: #333;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
            color: #444;
        }

        input, select {
            width: 100%;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        textarea {
            width: 100%;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 6px;
            resize: vertical;
            height: 45px;
        }

        .full {
            grid-column: span 3;
        }

        .btn {
            margin-top: 20px;
            padding: 12px 25px;
            background: #6a1b9a;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
        }

        .btn:hover {
            background: #4a148c;
        }

        .message {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 6px;
            background: #e8f5e9;
            color: #2e7d32;
            font-weight: bold;
        }

        .error {
            background: #ffebee;
            color: #c62828;
        }

        .search-box {
            margin-bottom: 20px;
        }

        .search-box input {
            max-width: 400px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th {
            background: #6a1b9a;
            color: white;
            padding: 12px;
            text-align: left;
        }

        td {
            padding: 11px;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background: #f5f5f5;
        }

        .edit {
            color: #1565c0;
            text-decoration: none;
            font-weight: bold;
            margin-right: 10px;
        }

        .delete {
            color: #c62828;
            text-decoration: none;
            font-weight: bold;
        }

        .status {
            padding: 5px 10px;
            border-radius: 15px;
            background: #e8f5e9;
            color: #2e7d32;
            font-size: 12px;
            font-weight: bold;
        }

        @media(max-width: 900px) {

            .form-grid {
                grid-template-columns: 1fr;
            }

            .full {
                grid-column: span 1;
            }

            table {
                font-size: 12px;
            }

        }

    </style>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>

<div class="header">
    Smart Dairy - Distributor Management
</div>

<div class="container">

    <% if ("true".equals(request.getParameter("success"))) { %>

        <div class="message">
            Distributor added successfully.
        </div>

    <% } %>

    <% if ("true".equals(request.getParameter("updated"))) { %>

        <div class="message">
            Distributor updated successfully.
        </div>

    <% } %>

    <% if ("true".equals(request.getParameter("deleted"))) { %>

        <div class="message">
            Distributor deleted successfully.
        </div>

    <% } %>

    <% if ("true".equals(request.getParameter("error"))) { %>

        <div class="message error">
            Something went wrong. Please try again.
        </div>

    <% } %>


    <!-- ADD DISTRIBUTOR -->

    <div class="card">

        <h2>Add Distributor</h2>

        <form action="DistributorController" method="post">

            <div class="form-grid">

                <div>

                    <label>Distributor Name</label>

                    <input type="text"
                           name="name"
                           placeholder="Enter distributor name"
                           required>

                </div>


                <div>

                    <label>Mobile Number</label>

                    <input type="text"
                           name="mobile"
                           placeholder="Enter mobile number"
                           maxlength="15"
                           required>

                </div>


                <div>

                    <label>Shop / Company Name</label>

                    <input type="text"
                           name="shop_name"
                           placeholder="Enter shop or company name">

                </div>


                <div>

                    <label>Area</label>

                    <input type="text"
                           name="area"
                           placeholder="Enter area">

                </div>


                <div>

                    <label>Status</label>

                    <select name="status">

                        <option value="ACTIVE">ACTIVE</option>

                        <option value="INACTIVE">INACTIVE</option>

                    </select>

                </div>


                <div class="full">

                    <label>Address</label>

                    <textarea name="address"
                              placeholder="Enter complete address"></textarea>

                </div>

            </div>


            <button type="submit" class="btn">
                Add Distributor
            </button>

        </form>

    </div>


    <!-- DISTRIBUTOR LIST -->

    <div class="card">

        <h2>Distributor List</h2>


        <div class="search-box">

            <input type="text"
                   id="searchInput"
                   placeholder="Search distributor..."
                   onkeyup="searchTable()">

        </div>


        <table id="distributorTable">

            <thead>

                <tr>

                    <th>ID</th>
                    <th>Name</th>
                    <th>Mobile</th>
                    <th>Shop / Company</th>
                    <th>Area</th>
                    <th>Address</th>
                    <th>Status</th>
                    <th>Action</th>

                </tr>

            </thead>

            <tbody>

            <%

                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {

                    con = DBConnection.getConnection();

                    String sql =
                            "SELECT * FROM distributors "
                            + "ORDER BY id DESC";

                    ps = con.prepareStatement(sql);

                    rs = ps.executeQuery();

                    while (rs.next()) {

            %>

                <tr>

                    <td>
                        <%= rs.getInt("id") %>
                    </td>

                    <td>
                        <%= rs.getString("name") %>
                    </td>

                    <td>
                        <%= rs.getString("mobile") %>
                    </td>

                    <td>
                        <%= rs.getString("shop_name") %>
                    </td>

                    <td>
                        <%= rs.getString("area") %>
                    </td>

                    <td>
                        <%= rs.getString("address") %>
                    </td>

                    <td>

                        <span class="status">
                            <%= rs.getString("status") %>
                        </span>

                    </td>

                    <td>

                        <a class="edit"
                           href="distributor_edit.jsp?id=<%= rs.getInt("id") %>">
                            Edit
                        </a>

                        <a class="delete"
                           href="DistributorDeleteServlet?id=<%= rs.getInt("id") %>"
                           onclick="return confirm('Are you sure you want to delete this distributor?');">
                            Delete
                        </a>

                    </td>

                </tr>

            <%

                    }

                } catch (Exception e) {

                    out.println(
                        "<tr><td colspan='8'>"
                        + "Error loading distributors: "
                        + e.getMessage()
                        + "</td></tr>"
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

            </tbody>

        </table>

    </div>

</div>


<script>

function searchTable() {

    let input =
        document.getElementById("searchInput");

    let filter =
        input.value.toLowerCase();

    let table =
        document.getElementById("distributorTable");

    let rows =
        table.getElementsByTagName("tr");


    for (let i = 1; i < rows.length; i++) {

        let text =
            rows[i].innerText.toLowerCase();

        if (text.includes(filter)) {

            rows[i].style.display = "";

        } else {

            rows[i].style.display = "none";

        }

    }

}

</script>

</body>
</html>