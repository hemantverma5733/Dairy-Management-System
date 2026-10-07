<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Edit Delivery - Smart Dairy</title>

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
            width: 75%;
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

        input,
        select,
        textarea {
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

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>

<div class="header">
    Smart Dairy - Edit Delivery
</div>

<div class="container">

<div class="card">

<h2>Edit Delivery</h2>

<%

    String id = request.getParameter("id");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {

        con = DBConnection.getConnection();

        String sql =
                "SELECT * FROM deliveries WHERE id = ?";

        ps = con.prepareStatement(sql);

        ps.setInt(1, Integer.parseInt(id));

        rs = ps.executeQuery();

        if (rs.next()) {

%>

<form action="DeliveryUpdateServlet" method="post">

    <input type="hidden"
           name="id"
           value="<%= rs.getInt("id") %>">


    <div class="form-grid">


        <!-- ORDER -->

        <div>

            <label>Order ID</label>

            <input type="number"
                   name="order_id"
                   value="<%= rs.getInt("order_id") %>"
                   required>

        </div>


        <!-- DELIVERY PERSON -->

        <div>

            <label>Delivery Person</label>

            <input type="text"
                   name="delivery_person"
                   value="<%= rs.getString("delivery_person") %>"
                   required>

        </div>


        <!-- MOBILE -->

        <div>

            <label>Mobile Number</label>

            <input type="text"
                   name="mobile"
                   value="<%= rs.getString("mobile") %>"
                   maxlength="15">

        </div>


        <!-- VEHICLE -->

        <div>

            <label>Vehicle Number</label>

            <input type="text"
                   name="vehicle_number"
                   value="<%= rs.getString("vehicle_number") %>">

        </div>


        <!-- DELIVERY DATE -->

        <div>

            <label>Delivery Date</label>

            <input type="date"
                   name="delivery_date"
                   value="<%= rs.getDate("delivery_date") %>"
                   required>

        </div>


        <!-- ROUTE -->

        <div>

            <label>Route / Area</label>

            <input type="text"
                   name="route"
                   value="<%= rs.getString("route") %>">

        </div>


        <!-- STATUS -->

        <div>

            <label>Status</label>

            <select name="status">

                <option value="ASSIGNED"
                    <%= "ASSIGNED".equals(rs.getString("status"))
                    ? "selected" : "" %>>
                    ASSIGNED
                </option>

                <option value="OUT FOR DELIVERY"
                    <%= "OUT FOR DELIVERY".equals(rs.getString("status"))
                    ? "selected" : "" %>>
                    OUT FOR DELIVERY
                </option>

                <option value="DELIVERED"
                    <%= "DELIVERED".equals(rs.getString("status"))
                    ? "selected" : "" %>>
                    DELIVERED
                </option>

                <option value="FAILED"
                    <%= "FAILED".equals(rs.getString("status"))
                    ? "selected" : "" %>>
                    FAILED
                </option>

                <option value="CANCELLED"
                    <%= "CANCELLED".equals(rs.getString("status"))
                    ? "selected" : "" %>>
                    CANCELLED
                </option>

            </select>

        </div>


        <!-- REMARKS -->

        <div class="full">

            <label>Remarks</label>

            <textarea name="remarks"><%= rs.getString("remarks") %></textarea>

        </div>

    </div>


    <button type="submit" class="btn">
        Update Delivery
    </button>

    <a href="delivery.jsp" class="back">
        Back
    </a>

</form>

<%

        } else {

            out.println("<h3>Delivery record not found.</h3>");

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