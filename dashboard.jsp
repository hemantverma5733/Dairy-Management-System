<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<%
    double todayMilk = 0;
    int totalCustomers = 0;
    int totalOrders = 0;
    double pendingPayments = 0;
    double todaySales = 0;
    double todayExpenses = 0;
    double todayProfit = 0;

    Connection con = null;

    try {

        con = DBConnection.getConnection();

        // TODAY'S MILK
        String sql1 =
            "SELECT COALESCE(SUM(quantity),0) " +
            "FROM milk_collection " +
            "WHERE collection_date = CURDATE()";

        PreparedStatement ps1 = con.prepareStatement(sql1);
        ResultSet rs1 = ps1.executeQuery();

        if (rs1.next()) {
            todayMilk = rs1.getDouble(1);
        }

        rs1.close();
        ps1.close();


        // TOTAL CUSTOMERS
        String sql2 =
            "SELECT COUNT(*) FROM customers " +
            "WHERE status = 'ACTIVE'";

        PreparedStatement ps2 = con.prepareStatement(sql2);
        ResultSet rs2 = ps2.executeQuery();

        if (rs2.next()) {
            totalCustomers = rs2.getInt(1);
        }

        rs2.close();
        ps2.close();


        // TOTAL ORDERS
        String sql3 =
            "SELECT COUNT(*) FROM orders " +
            "WHERE status <> 'CANCELLED'";

        PreparedStatement ps3 = con.prepareStatement(sql3);
        ResultSet rs3 = ps3.executeQuery();

        if (rs3.next()) {
            totalOrders = rs3.getInt(1);
        }

        rs3.close();
        ps3.close();


        // PENDING PAYMENTS
        String sql4 =
            "SELECT COALESCE(SUM(pending_amount),0) " +
            "FROM invoices " +
            "WHERE pending_amount > 0";

        PreparedStatement ps4 = con.prepareStatement(sql4);
        ResultSet rs4 = ps4.executeQuery();

        if (rs4.next()) {
            pendingPayments = rs4.getDouble(1);
        }

        rs4.close();
        ps4.close();


        // TODAY'S SALES
        String sql5 =
            "SELECT COALESCE(SUM(total_amount),0) " +
            "FROM orders " +
            "WHERE order_date = CURDATE() " +
            "AND status <> 'CANCELLED'";

        PreparedStatement ps5 = con.prepareStatement(sql5);
        ResultSet rs5 = ps5.executeQuery();

        if (rs5.next()) {
            todaySales = rs5.getDouble(1);
        }

        rs5.close();
        ps5.close();


        // TODAY'S EXPENSES
        String sql6 =
            "SELECT COALESCE(SUM(amount),0) " +
            "FROM expenses " +
            "WHERE expense_date = CURDATE()";

        PreparedStatement ps6 = con.prepareStatement(sql6);
        ResultSet rs6 = ps6.executeQuery();

        if (rs6.next()) {
            todayExpenses = rs6.getDouble(1);
        }

        rs6.close();
        ps6.close();


        // TODAY'S PROFIT
        todayProfit = todaySales - todayExpenses;


    } catch (Exception e) {

        e.printStackTrace();

    } finally {

        try {
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
%>


<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Smart Dairy - Dashboard</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f7f6;
        }

        /* HEADER */

        .header {
            background: #2e7d32;
            color: white;
            padding: 18px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h2 {
            margin: 0;
        }

        .logout {
            background: white;
            color: #2e7d32;
            padding: 9px 16px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
        }

        /* MAIN */

        .container {
            padding: 30px;
        }

        .welcome {
            margin-bottom: 25px;
        }

        .welcome h1 {
            margin-bottom: 5px;
        }

        .welcome p {
            color: #666;
        }

        /* CARDS */

        .cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .card h3 {
            margin-top: 0;
            color: #2e7d32;
        }

        .number {
            font-size: 28px;
            font-weight: bold;
            color: #222;
        }

        /* MODULES */

        .module-box {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .module-box h2 {
            margin-top: 0;
            color: #333;
        }

        .modules {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
        }

        .module {
            text-decoration: none;
            background: #f1f8f3;
            color: #2e7d32;
            padding: 16px;
            text-align: center;
            border-radius: 8px;
            font-weight: bold;
            border: 1px solid #d8eadb;
        }

        .module:hover {
            background: #dff0e2;
        }

        /* PROFIT */

        .profit-box {
            margin-top: 25px;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .profit-box h2 {
            margin-top: 0;
        }

        .profit-value {
            font-size: 30px;
            font-weight: bold;
            color: #2e7d32;
        }

        /* RESPONSIVE */

        @media (max-width: 1000px) {

            .cards,
            .modules {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 600px) {

            .cards,
            .modules {
                grid-template-columns: 1fr;
            }

            .container {
                padding: 15px;
            }

            .header {
                padding: 15px;
            }
        }

    </style>

</head>


<body>


    <!-- HEADER -->

    <div class="header">

        <h2>Smart Dairy</h2>

        <a href="login.jsp" class="logout">
            Logout
        </a>

    </div>


    <!-- MAIN CONTAINER -->

    <div class="container">


        <!-- WELCOME -->

        <div class="welcome">

            <h1>Dashboard</h1>

            <p>
                Welcome to Smart Dairy Management System
            </p>

        </div>


        <!-- LIVE SUMMARY CARDS -->

        <div class="cards">


            <!-- MILK -->

            <div class="card">

                <h3>Today's Milk</h3>

                <div class="number">

                    <%= String.format("%.2f", todayMilk) %> L

                </div>

            </div>


            <!-- CUSTOMERS -->

            <div class="card">

                <h3>Customers</h3>

                <div class="number">

                    <%= totalCustomers %>

                </div>

            </div>


            <!-- ORDERS -->

            <div class="card">

                <h3>Orders</h3>

                <div class="number">

                    <%= totalOrders %>

                </div>

            </div>


            <!-- PENDING PAYMENT -->

            <div class="card">

                <h3>Pending Payments</h3>

                <div class="number">

                    Rs. <%= String.format("%.2f", pendingPayments) %>

                </div>

            </div>


            <!-- TODAY SALES -->

            <div class="card">

                <h3>Today's Sales</h3>

                <div class="number">

                    Rs. <%= String.format("%.2f", todaySales) %>

                </div>

            </div>


            <!-- TODAY EXPENSE -->

            <div class="card">

                <h3>Today's Expenses</h3>

                <div class="number">

                    Rs. <%= String.format("%.2f", todayExpenses) %>

                </div>

            </div>


            <!-- TODAY PROFIT -->

            <div class="card">

                <h3>Today's Profit</h3>

                <div class="number">

                    Rs. <%= String.format("%.2f", todayProfit) %>

                </div>

            </div>


        </div>


        <!-- MODULES -->

        <div class="module-box">

            <h2>Management Modules</h2>

            <div class="modules">


                <a href="milk_collection.jsp"
                   class="module">
                    Milk Collection
                </a>


                <a href="milk_records.jsp"
                   class="module">
                    Milk Records
                </a>


                <a href="supplier.jsp"
                   class="module">
                    Suppliers
                </a>


                <a href="customer.jsp"
                   class="module">
                    Customers
                </a>


                <a href="product.jsp"
                   class="module">
                    Products
                </a>


                <a href="inventory.jsp"
                   class="module">
                    Inventory
                </a>


                <a href="order.jsp"
                   class="module">
                    Orders
                </a>


                <a href="payment.jsp"
                   class="module">
                    Payments
                </a>


                <a href="invoice.jsp"
                   class="module">
                    Invoices
                </a>


                <a href="distributor.jsp"
                   class="module">
                    Distributors
                </a>


                <a href="delivery.jsp"
                   class="module">
                    Delivery
                </a>


                <a href="subscription.jsp"
                   class="module">
                    Subscriptions
                </a>


                <a href="expense.jsp"
                   class="module">
                    Expenses
                </a>


                <a href="reports.jsp"
                   class="module">
                    Reports
                </a>


                <a href="daily_report.jsp"
                   class="module">
                    Daily Report
                </a>


                <a href="expense_report.jsp"
                   class="module">
                    Expense Report
                </a>


            </div>

        </div>


        <!-- PROFIT SUMMARY -->

        <div class="profit-box">

            <h2>Today's Business Performance</h2>

            <p>
                Today's Sales:
                <strong>
                    Rs. <%= String.format("%.2f", todaySales) %>
                </strong>
            </p>

            <p>
                Today's Expenses:
                <strong>
                    Rs. <%= String.format("%.2f", todayExpenses) %>
                </strong>
            </p>

            <hr>

            <div class="profit-value">

                Net Profit:
                Rs. <%= String.format("%.2f", todayProfit) %>

            </div>

        </div>


    </div>


</body>

</html>