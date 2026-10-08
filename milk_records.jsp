<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Milk Collection Records - Smart Dairy</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f7fb;
        }

        .header {
            background: #243b53;
            color: white;
            padding: 20px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            margin: 0;
            font-size: 26px;
        }

        .back {
            color: white;
            text-decoration: none;
            background: #486581;
            padding: 10px 18px;
            border-radius: 6px;
        }

        .back:hover {
            background: #334e68;
        }

        .container {
            padding: 30px;
        }

        .summary {
            display: flex;
            gap: 20px;
            margin-bottom: 25px;
        }

        .card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            min-width: 270px;
        }

        .card h3 {
            margin: 0 0 10px;
            color: #486581;
        }

        .card p {
            margin: 0;
            font-size: 24px;
            font-weight: bold;
        }

        .table-box {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            overflow-x: auto;
        }

        .table-box h2 {
            margin-top: 0;
            margin-bottom: 25px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #243b53;
            color: white;
            padding: 12px;
            text-align: left;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background: #f5f8fa;
        }

        .add-btn {
            display: inline-block;
            margin-bottom: 25px;
            background: #2f855a;
            color: white;
            text-decoration: none;
            padding: 11px 18px;
            border-radius: 6px;
        }

        .add-btn:hover {
            background: #276749;
        }

    </style>

</head>

<body>

    <!-- HEADER -->

    <div class="header">

        <h1>Smart Dairy - Milk Collection</h1>

        <a class="back" href="dashboard.jsp">
            Dashboard
        </a>

    </div>


    <!-- MAIN CONTAINER -->

    <div class="container">

        <!-- ADD MILK BUTTON -->

        <a class="add-btn" href="milk_collection.jsp">
            + Add Milk Collection
        </a>


        <!-- SUMMARY CARDS -->

        <div class="summary">


            <!-- TOTAL MILK -->

            <div class="card">

                <h3>Total Milk</h3>

                <p>

                    <%
                        double totalMilk = 0;

                        try {

                            Connection con = DBConnection.getConnection();

                            PreparedStatement ps = con.prepareStatement(
                                "SELECT COALESCE(SUM(quantity),0) FROM milk_collection"
                            );

                            ResultSet rs = ps.executeQuery();

                            if (rs.next()) {
                                totalMilk = rs.getDouble(1);
                            }

                            rs.close();
                            ps.close();
                            con.close();

                        } catch (Exception e) {

                            totalMilk = 0;

                        }
                    %>

                    <%= String.format("%.2f", totalMilk) %> L

                </p>

            </div>


            <!-- TOTAL AMOUNT -->

            <div class="card">

                <h3>Total Amount</h3>

                <p>

                    <%
                        double totalAmount = 0;

                        try {

                            Connection con = DBConnection.getConnection();

                            PreparedStatement ps = con.prepareStatement(
                                "SELECT COALESCE(SUM(amount),0) FROM milk_collection"
                            );

                            ResultSet rs = ps.executeQuery();

                            if (rs.next()) {
                                totalAmount = rs.getDouble(1);
                            }

                            rs.close();
                            ps.close();
                            con.close();

                        } catch (Exception e) {

                            totalAmount = 0;

                        }
                    %>

                    Rs. <%= String.format("%.2f", totalAmount) %>

                </p>

            </div>

        </div>


        <!-- MILK COLLECTION TABLE -->

        <div class="table-box">

            <h2>Milk Collection Records</h2>

            <table>

                <tr>

                    <th>ID</th>
                    <th>Date</th>
                    <th>Supplier</th>
                    <th>Shift</th>
                    <th>Animal</th>
                    <th>Quantity (L)</th>
                    <th>Fat %</th>
                    <th>SNF %</th>
                    <th>Rate</th>
                    <th>Amount</th>

                </tr>


                <%

                    try {

                        Connection con = DBConnection.getConnection();

                        PreparedStatement ps = con.prepareStatement(
                            "SELECT * FROM milk_collection ORDER BY id DESC"
                        );

                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {

                %>


                <tr>

                    <td>
                        <%= rs.getInt("id") %>
                    </td>

                    <td>
                        <%= rs.getDate("collection_date") %>
                    </td>

                    <td>
                        <%= rs.getString("supplier_name") %>
                    </td>

                    <td>
                        <%= rs.getString("shift") %>
                    </td>

                    <td>
                        <%= rs.getString("animal_type") %>
                    </td>

                    <td>
                        <%= rs.getDouble("quantity") %>
                    </td>

                    <td>
                        <%= rs.getDouble("fat") %>
                    </td>

                    <td>
                        <%= rs.getDouble("snf") %>
                    </td>

                    <td>
                        Rs. <%= rs.getDouble("rate") %>
                    </td>

                    <td>
                        Rs. <%= rs.getDouble("amount") %>
                    </td>

                </tr>


                <%

                        }

                        rs.close();
                        ps.close();
                        con.close();

                    } catch (Exception e) {

                %>


                <tr>

                    <td colspan="10">

                        Error loading records:
                        <%= e.getMessage() %>

                    </td>

                </tr>


                <%

                    }

                %>


            </table>

        </div>

    </div>

</body>
</html>