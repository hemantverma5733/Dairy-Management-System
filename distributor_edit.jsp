<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Edit Distributor - Smart Dairy</title>

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
            width: 70%;
            margin: 35px auto;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
        }

        h2 {
            margin-top: 0;
            color: #333;
            margin-bottom: 25px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: bold;
            color: #444;
        }

        input, select, textarea {
            width: 100%;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        textarea {
            height: 80px;
            resize: vertical;
        }

        .full {
            grid-column: span 2;
        }

        .btn {
            margin-top: 25px;
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

        .back {
            display: inline-block;
            margin-left: 10px;
            padding: 12px 22px;
            background: #777;
            color: white;
            text-decoration: none;
            border-radius: 6px;
        }

    </style>

</head>

<body>

<div class="header">
    Smart Dairy - Edit Distributor
</div>

<div class="container">

<div class="card">

<h2>Edit Distributor</h2>

<%

    String id = request.getParameter("id");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {

        con = DBConnection.getConnection();

        String sql =
                "SELECT * FROM distributors WHERE id = ?";

        ps = con.prepareStatement(sql);

        ps.setInt(1, Integer.parseInt(id));

        rs = ps.executeQuery();

        if (rs.next()) {

%>

<form action="DistributorUpdateServlet" method="post">

    <input type="hidden"
           name="id"
           value="<%= rs.getInt("id") %>">


    <div class="form-grid">

        <div>

            <label>Distributor Name</label>

            <input type="text"
                   name="name"
                   value="<%= rs.getString("name") %>"
                   required>

        </div>


        <div>

            <label>Mobile Number</label>

            <input type="text"
                   name="mobile"
                   value="<%= rs.getString("mobile") %>"
                   maxlength="15"
                   required>

        </div>


        <div>

            <label>Shop / Company Name</label>

            <input type="text"
                   name="shop_name"
                   value="<%= rs.getString("shop_name") %>">

        </div>


        <div>

            <label>Area</label>

            <input type="text"
                   name="area"
                   value="<%= rs.getString("area") %>">

        </div>


        <div>

            <label>Status</label>

            <select name="status">

                <option value="ACTIVE"
                    <%= "ACTIVE".equals(rs.getString("status"))
                    ? "selected" : "" %>>
                    ACTIVE
                </option>

                <option value="INACTIVE"
                    <%= "INACTIVE".equals(rs.getString("status"))
                    ? "selected" : "" %>>
                    INACTIVE
                </option>

            </select>

        </div>


        <div class="full">

            <label>Address</label>

            <textarea name="address"><%= rs.getString("address") %></textarea>

        </div>

    </div>


    <button type="submit" class="btn">
        Update Distributor
    </button>

    <a href="distributor.jsp" class="back">
        Back
    </a>

</form>

<%

        } else {

            out.println("<h3>Distributor not found.</h3>");

        }

    } catch (Exception e) {

        out.println(
            "<h3>Error: "
            + e.getMessage()
            + "</h3>"
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