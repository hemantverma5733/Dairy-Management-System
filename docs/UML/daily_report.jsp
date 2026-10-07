<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<%
    String fromDate = request.getParameter("from_date");
    String toDate = request.getParameter("to_date");

    if (fromDate == null || fromDate.trim().isEmpty()) {
        fromDate = "";
    }

    if (toDate == null || toDate.trim().isEmpty()) {
        toDate = "";
    }

    double totalMilk = 0;
    double totalSales = 0;
    double totalPayments = 0;
    int totalOrders = 0;
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Daily & Monthly Report - Smart Dairy</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f5f7;
            color: #333;
        }

        .topbar {
            background: #6f1d3b;
            color: white;
            padding: 18px 35px;

            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .topbar h2 {
            margin: 0;
        }

        .topbar a {
            color: white;
            text-decoration: none;
            background: #ffffff22;
            padding: 10px 18px;
            border-radius: 6px;
        }

        .container {
            max-width: 1250px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .heading h1 {
            margin: 0;
            color: #6f1d3b;
        }

        .heading p {
            color: #777;
        }

        .filter-box {
            background: white;
            padding: 25px;
            border-radius: 10px;

            box-shadow:
                0 3px 12px
                rgba(0,0,0,0.08);

            margin-top: 25px;
        }

        .filter-form {
            display: grid;
            grid-template-columns: 1fr 1fr auto;
            gap: 15px;
            align-items: end;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 7px;
        }

        input[type="date"] {
            width: 100%;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        .btn {
            background: #6f1d3b;
            color: white;
            border: none;
            padding: 11px 25px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
        }

        .btn:hover {
            opacity: 0.9;
        }

        .summary {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-top: 25px;
        }

        .card {
            background: white;
            padding: 22px;
            border-radius: 10px;

            box-shadow:
                0 3px 12px
                rgba(0,0,0,0.08);
        }

        .card h3 {
            margin: 0 0 12px;
            font-size: 15px;
            color: #666;
        }

        .value {
            font-size: 25px;
            font-weight: bold;
            color: #6f1d3b;
        }

        .section {
            margin-top: 30px;
        }

        .section h2 {
            color: #6f1d3b;
        }

        .table-box {
            background: white;
            padding: 20px;
            border-radius: 10px;

            box-shadow:
                0 3px 12px
                rgba(0,0,0,0.08);

            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #6f1d3b;
            color: white;
            padding: 12px;
            text-align: left;
            white-space: nowrap;
        }

        td {
            padding: 11px;
            border-bottom: 1px solid #ddd;
            white-space: nowrap;
        }

        tr:hover {
            background: #faf5f7;
        }

        .no-data {
            text-align: center;
            padding: 25px;
            color: #777;
        }

        .print-area {
            text-align: right;
            margin-top: 20px;
        }

        .print-btn {
            background: #555;
        }

        @media print {

            .topbar,
            .filter-box,
            .print-area {
                display: none;
            }

            body {
                background: white;
            }

            .container {
                margin: 0;
                max-width: 100%;
            }

            .card,
            .table-box {
                box-shadow: none;
            }

        }

        @media (max-width: 900px) {

            .summary {
                grid-template-columns: repeat(2, 1fr);
            }

            .filter-form {
                grid-template-columns: 1fr;
            }

        }

        @media (max-width: 600px) {

            .summary {
                grid-template-columns: 1fr;
            }

        }

    </style>

</head>


<body>


<div class="topbar">

    <h2>Smart Dairy</h2>

    <a href="reports.jsp">
        Back to Reports
    </a>

</div>


<div class="container">


    <div class="heading">

        <h1>Daily & Monthly Report</h1>

        <p>
            Select a date range to view dairy business performance.
        </p>

    </div>


    <!-- DATE FILTER -->

    <div class="filter-box">

        <form method="get"
              action="daily_report.jsp"
              class="filter-form">


            <div>

                <label>From Date</label>

                <input
                    type="date"
                    name="from_date"
                    value="<%= fromDate %>"
                    required>

            </div>


            <div>

                <label>To Date</label>

                <input
                    type="date"
                    name="to_date"
                    value="<%= toDate %>"
                    required>

            </div>


            <div>

                <button
                    type="submit"
                    class="btn">

                    Generate Report

                </button>

            </div>


        </form>

    </div>


<%

    if (!fromDate.isEmpty() && !toDate.isEmpty()) {

        Connection con = null;

        try {

            con = DBConnection.getConnection();


            // TOTAL MILK

            String milkSql =
                "SELECT COALESCE(SUM(quantity), 0) " +
                "FROM milk_collection " +
                "WHERE collection_date BETWEEN ? AND ?";

            PreparedStatement milkPs =
                con.prepareStatement(milkSql);

            milkPs.setString(1, fromDate);
            milkPs.setString(2, toDate);

            ResultSet milkRs =
                milkPs.executeQuery();

            if (milkRs.next()) {
                totalMilk = milkRs.getDouble(1);
            }

            milkRs.close();
            milkPs.close();


            // TOTAL SALES

            String salesSql =
                "SELECT COALESCE(SUM(total_amount), 0) " +
                "FROM orders " +
                "WHERE order_date BETWEEN ? AND ? " +
                "AND status <> 'CANCELLED'";

            PreparedStatement salesPs =
                con.prepareStatement(salesSql);

            salesPs.setString(1, fromDate);
            salesPs.setString(2, toDate);

            ResultSet salesRs =
                salesPs.executeQuery();

            if (salesRs.next()) {
                totalSales = salesRs.getDouble(1);
            }

            salesRs.close();
            salesPs.close();


            // TOTAL PAYMENTS

            String paymentSql =
                "SELECT COALESCE(SUM(amount), 0) " +
                "FROM payments " +
                "WHERE payment_date BETWEEN ? AND ? " +
                "AND payment_status = 'RECEIVED'";

            PreparedStatement paymentPs =
                con.prepareStatement(paymentSql);

            paymentPs.setString(1, fromDate);
            paymentPs.setString(2, toDate);

            ResultSet paymentRs =
                paymentPs.executeQuery();

            if (paymentRs.next()) {
                totalPayments = paymentRs.getDouble(1);
            }

            paymentRs.close();
            paymentPs.close();


            // TOTAL ORDERS

            String orderCountSql =
                "SELECT COUNT(*) " +
                "FROM orders " +
                "WHERE order_date BETWEEN ? AND ? " +
                "AND status <> 'CANCELLED'";

            PreparedStatement orderCountPs =
                con.prepareStatement(orderCountSql);

            orderCountPs.setString(1, fromDate);
            orderCountPs.setString(2, toDate);

            ResultSet orderCountRs =
                orderCountPs.executeQuery();

            if (orderCountRs.next()) {
                totalOrders = orderCountRs.getInt(1);
            }

            orderCountRs.close();
            orderCountPs.close();

%>


    <!-- SUMMARY -->

    <div class="summary">


        <div class="card">

            <h3>Total Milk Collection</h3>

            <div class="value">

                <%= String.format("%.2f", totalMilk) %>
                L

            </div>

        </div>


        <div class="card">

            <h3>Total Sales</h3>

            <div class="value">

                Rs.
                <%= String.format("%.2f", totalSales) %>

            </div>

        </div>


        <div class="card">

            <h3>Payments Received</h3>

            <div class="value">

                Rs.
                <%= String.format("%.2f", totalPayments) %>

            </div>

        </div>


        <div class="card">

            <h3>Total Orders</h3>

            <div class="value">

                <%= totalOrders %>

            </div>

        </div>


    </div>


    <!-- MILK DETAILS -->

    <div class="section">

        <h2>Milk Collection Details</h2>


        <div class="table-box">

            <table>

                <thead>

                    <tr>

                        <th>ID</th>
                        <th>Date</th>
                        <th>Supplier</th>
                        <th>Shift</th>
                        <th>Animal</th>
                        <th>Quantity</th>
                        <th>Fat</th>
                        <th>SNF</th>
                        <th>Rate</th>
                        <th>Amount</th>

                    </tr>

                </thead>


                <tbody>

<%

            String milkDetailsSql =
                "SELECT * FROM milk_collection " +
                "WHERE collection_date BETWEEN ? AND ? " +
                "ORDER BY collection_date DESC, id DESC";

            PreparedStatement milkDetailsPs =
                con.prepareStatement(milkDetailsSql);

            milkDetailsPs.setString(1, fromDate);
            milkDetailsPs.setString(2, toDate);

            ResultSet milkDetailsRs =
                milkDetailsPs.executeQuery();

            boolean milkFound = false;

            while (milkDetailsRs.next()) {

                milkFound = true;

%>

                    <tr>

                        <td>
                            <%= milkDetailsRs.getInt("id") %>
                        </td>

                        <td>
                            <%= milkDetailsRs.getDate("collection_date") %>
                        </td>

                        <td>
                            <%= milkDetailsRs.getString("supplier_name") %>
                        </td>

                        <td>
                            <%= milkDetailsRs.getString("shift") %>
                        </td>

                        <td>
                            <%= milkDetailsRs.getString("animal_type") %>
                        </td>

                        <td>
                            <%= milkDetailsRs.getDouble("quantity") %> L
                        </td>

                        <td>
                            <%= milkDetailsRs.getDouble("fat") %>%
                        </td>

                        <td>
                            <%= milkDetailsRs.getDouble("snf") %>%
                        </td>

                        <td>
                            Rs.
                            <%= milkDetailsRs.getDouble("rate") %>
                        </td>

                        <td>
                            Rs.
                            <%= milkDetailsRs.getDouble("amount") %>
                        </td>

                    </tr>

<%

            }

            if (!milkFound) {

%>

                    <tr>

                        <td colspan="10"
                            class="no-data">

                            No milk collection records found.

                        </td>

                    </tr>

<%

            }

            milkDetailsRs.close();
            milkDetailsPs.close();

%>

                </tbody>

            </table>

        </div>

    </div>


    <!-- SALES DETAILS -->

    <div class="section">

        <h2>Sales / Order Details</h2>


        <div class="table-box">

            <table>

                <thead>

                    <tr>

                        <th>Order ID</th>
                        <th>Date</th>
                        <th>Customer</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Payment Status</th>

                    </tr>

                </thead>


                <tbody>

<%

            String orderDetailsSql =
                "SELECT o.id, o.order_date, " +
                "c.name AS customer_name, " +
                "o.total_amount, o.status, " +
                "o.payment_status " +
                "FROM orders o " +
                "JOIN customers c " +
                "ON o.customer_id = c.id " +
                "WHERE o.order_date BETWEEN ? AND ? " +
                "AND o.status <> 'CANCELLED' " +
                "ORDER BY o.order_date DESC, o.id DESC";

            PreparedStatement orderDetailsPs =
                con.prepareStatement(orderDetailsSql);

            orderDetailsPs.setString(1, fromDate);
            orderDetailsPs.setString(2, toDate);

            ResultSet orderDetailsRs =
                orderDetailsPs.executeQuery();

            boolean orderFound = false;

            while (orderDetailsRs.next()) {

                orderFound = true;

%>

                    <tr>

                        <td>
                            #<%= orderDetailsRs.getInt("id") %>
                        </td>

                        <td>
                            <%= orderDetailsRs.getDate("order_date") %>
                        </td>

                        <td>
                            <%= orderDetailsRs.getString("customer_name") %>
                        </td>

                        <td>
                            Rs.
                            <%= orderDetailsRs.getDouble("total_amount") %>
                        </td>

                        <td>
                            <%= orderDetailsRs.getString("status") %>
                        </td>

                        <td>
                            <%= orderDetailsRs.getString("payment_status") %>
                        </td>

                    </tr>

<%

            }

            if (!orderFound) {

%>

                    <tr>

                        <td colspan="6"
                            class="no-data">

                            No sales/order records found.

                        </td>

                    </tr>

<%

            }

            orderDetailsRs.close();
            orderDetailsPs.close();

%>

                </tbody>

            </table>

        </div>

    </div>


    <!-- PRINT -->

    <div class="print-area">

        <button
            class="btn print-btn"
            onclick="window.print()">

            Print Report

        </button>

    </div>


<%

            con.close();

        } catch (Exception e) {

            e.printStackTrace();

%>

        <div class="filter-box">

            <strong>
                Error generating report:
            </strong>

            <br><br>

            <%= e.getMessage() %>

        </div>

<%

        } finally {

            try {
                if (con != null) con.close();
            } catch (Exception e) {
            }

        }

    }

%>


</div>


</body>

</html>