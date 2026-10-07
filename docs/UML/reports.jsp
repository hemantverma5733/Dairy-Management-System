
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<%
    double todayMilk = 0;
    double monthMilk = 0;
    double todaySales = 0;
    double monthSales = 0;
    double totalPayments = 0;
    double pendingPayments = 0;
    double todayExpenses = 0;
    double monthExpenses = 0;

    Connection con = null;

    try {

        con = DBConnection.getConnection();

        // TODAY MILK
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


        // MONTH MILK
        String sql2 =
            "SELECT COALESCE(SUM(quantity),0) " +
            "FROM milk_collection " +
            "WHERE MONTH(collection_date) = MONTH(CURDATE()) " +
            "AND YEAR(collection_date) = YEAR(CURDATE())";

        PreparedStatement ps2 = con.prepareStatement(sql2);
        ResultSet rs2 = ps2.executeQuery();

        if (rs2.next()) {
            monthMilk = rs2.getDouble(1);
        }

        rs2.close();
        ps2.close();


        // TODAY SALES
        String sql3 =
            "SELECT COALESCE(SUM(total_amount),0) " +
            "FROM orders " +
            "WHERE order_date = CURDATE() " +
            "AND status <> 'CANCELLED'";

        PreparedStatement ps3 = con.prepareStatement(sql3);
        ResultSet rs3 = ps3.executeQuery();

        if (rs3.next()) {
            todaySales = rs3.getDouble(1);
        }

        rs3.close();
        ps3.close();


        // MONTH SALES
        String sql4 =
            "SELECT COALESCE(SUM(total_amount),0) " +
            "FROM orders " +
            "WHERE MONTH(order_date) = MONTH(CURDATE()) " +
            "AND YEAR(order_date) = YEAR(CURDATE()) " +
            "AND status <> 'CANCELLED'";

        PreparedStatement ps4 = con.prepareStatement(sql4);
        ResultSet rs4 = ps4.executeQuery();

        if (rs4.next()) {
            monthSales = rs4.getDouble(1);
        }

        rs4.close();
        ps4.close();


        // TOTAL PAYMENTS
        String sql5 =
            "SELECT COALESCE(SUM(amount),0) " +
            "FROM payments " +
            "WHERE payment_status = 'RECEIVED'";

        PreparedStatement ps5 = con.prepareStatement(sql5);
        ResultSet rs5 = ps5.executeQuery();

        if (rs5.next()) {
            totalPayments = rs5.getDouble(1);
        }

        rs5.close();
        ps5.close();


        // PENDING PAYMENTS
        String sql6 =
            "SELECT COALESCE(SUM(pending_amount),0) " +
            "FROM invoices";

        PreparedStatement ps6 = con.prepareStatement(sql6);
        ResultSet rs6 = ps6.executeQuery();

        if (rs6.next()) {
            pendingPayments = rs6.getDouble(1);
        }

        rs6.close();
        ps6.close();


        // TODAY EXPENSES
        String sql7 =
            "SELECT COALESCE(SUM(amount),0) " +
            "FROM expenses " +
            "WHERE expense_date = CURDATE()";

        PreparedStatement ps7 = con.prepareStatement(sql7);
        ResultSet rs7 = ps7.executeQuery();

        if (rs7.next()) {
            todayExpenses = rs7.getDouble(1);
        }

        rs7.close();
        ps7.close();


        // MONTH EXPENSES
        String sql8 =
            "SELECT COALESCE(SUM(amount),0) " +
            "FROM expenses " +
            "WHERE MONTH(expense_date) = MONTH(CURDATE()) " +
            "AND YEAR(expense_date) = YEAR(CURDATE())";

        PreparedStatement ps8 = con.prepareStatement(sql8);
        ResultSet rs8 = ps8.executeQuery();

        if (rs8.next()) {
            monthExpenses = rs8.getDouble(1);
        }

        rs8.close();
        ps8.close();

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


    double todayProfit = todaySales - todayExpenses;
    double monthProfit = monthSales - monthExpenses;
%>


<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Reports - Smart Dairy</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }

        .header {
            background: #243447;
            color: white;
            padding: 20px 35px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            margin: 0;
        }

        .back-btn {
            color: white;
            text-decoration: none;
            background: #607d8b;
            padding: 10px 18px;
            border-radius: 6px;
        }

        .container {
            width: 92%;
            margin: 30px auto;
        }

        .section-title {
            color: #243447;
            margin-bottom: 15px;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            padding: 22px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        .card h3 {
            margin-top: 0;
            color: #555;
            font-size: 16px;
        }

        .value {
            font-size: 28px;
            font-weight: bold;
            color: #243447;
        }

        .profit {
            border-left: 6px solid #2e7d32;
        }

        .expense {
            border-left: 6px solid #ef6c00;
        }

        .sales {
            border-left: 6px solid #1565c0;
        }

        .milk {
            border-left: 6px solid #6a1b9a;
        }

        .reports-box {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

        .report-links {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
        }

        .report-link {
            display: block;
            padding: 15px;
            text-align: center;
            background: #eef2f7;
            color: #243447;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
        }

        .report-link:hover {
            background: #dce4ec;
        }

        .profit-box {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        .profit-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .profit-item {
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .profit-item h3 {
            margin-top: 0;
        }

        .profit-number {
            font-size: 26px;
            font-weight: bold;
        }

        @media (max-width: 900px) {

            .cards {
                grid-template-columns: repeat(2, 1fr);
            }

            .report-links {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 600px) {

            .cards,
            .report-links,
            .profit-grid {
                grid-template-columns: 1fr;
            }
        }

    </style>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>


<body>


    <div class="header">

        <h1>Smart Dairy - Reports</h1>

        <a href="dashboard.jsp" class="back-btn">
            ← Dashboard
        </a>

    </div>


    <div class="container">


        <h2 class="section-title">
            Business Summary
        </h2>


        <div class="cards">


            <div class="card milk">

                <h3>Today's Milk</h3>

                <div class="value">
                    <%= String.format("%.2f", todayMilk) %> L
                </div>

            </div>


            <div class="card milk">

                <h3>This Month Milk</h3>

                <div class="value">
                    <%= String.format("%.2f", monthMilk) %> L
                </div>

            </div>


            <div class="card sales">

                <h3>Today's Sales</h3>

                <div class="value">
                    Rs. <%= String.format("%.2f", todaySales) %>
                </div>

            </div>


            <div class="card sales">

                <h3>This Month Sales</h3>

                <div class="value">
                    Rs. <%= String.format("%.2f", monthSales) %>
                </div>

            </div>


            <div class="card expense">

                <h3>Today's Expenses</h3>

                <div class="value">
                    Rs. <%= String.format("%.2f", todayExpenses) %>
                </div>

            </div>


            <div class="card expense">

                <h3>This Month Expenses</h3>

                <div class="value">
                    Rs. <%= String.format("%.2f", monthExpenses) %>
                </div>

            </div>


            <div class="card profit">

                <h3>Today's Profit</h3>

                <div class="value">
                    Rs. <%= String.format("%.2f", todayProfit) %>
                </div>

            </div>


            <div class="card profit">

                <h3>This Month Profit</h3>

                <div class="value">
                    Rs. <%= String.format("%.2f", monthProfit) %>
                </div>

            </div>


        </div>


        <!-- PROFIT / LOSS -->

        <div class="profit-box">

            <h2>Profit / Loss Summary</h2>

            <div class="profit-grid">


                <div class="profit-item">

                    <h3>Today's Calculation</h3>

                    <p>
                        Sales:
                        <strong>
                            Rs. <%= String.format("%.2f", todaySales) %>
                        </strong>
                    </p>

                    <p>
                        Expenses:
                        <strong>
                            Rs. <%= String.format("%.2f", todayExpenses) %>
                        </strong>
                    </p>

                    <hr>

                    <div class="profit-number">
                        Net:
                        Rs. <%= String.format("%.2f", todayProfit) %>
                    </div>

                </div>


                <div class="profit-item">

                    <h3>This Month Calculation</h3>

                    <p>
                        Sales:
                        <strong>
                            Rs. <%= String.format("%.2f", monthSales) %>
                        </strong>
                    </p>

                    <p>
                        Expenses:
                        <strong>
                            Rs. <%= String.format("%.2f", monthExpenses) %>
                        </strong>
                    </p>

                    <hr>

                    <div class="profit-number">
                        Net:
                        Rs. <%= String.format("%.2f", monthProfit) %>
                    </div>

                </div>


            </div>

        </div>


        <br>


        <!-- DETAILED REPORTS -->

        <div class="reports-box">

            <h2>Detailed Reports</h2>

            <div class="report-links">


                <a href="daily_report.jsp"
                   class="report-link">
                    Daily Report
                </a>


                <a href="milk_records.jsp"
                   class="report-link">
                    Milk Collection
                </a>


                <a href="customer.jsp"
                   class="report-link">
                    Customers
                </a>


                <a href="supplier.jsp"
                   class="report-link">
                    Suppliers
                </a>


                <a href="product.jsp"
                   class="report-link">
                    Products
                </a>


                <a href="order.jsp"
                   class="report-link">
                    Orders / Sales
                </a>


                <a href="payment.jsp"
                   class="report-link">
                    Payments
                </a>


                <a href="invoice.jsp"
                   class="report-link">
                    Invoices
                </a>


                <a href="expense.jsp"
                   class="report-link">
                    Expense Management
                </a>


                <a href="expense_report.jsp"
                   class="report-link">
                    Expense Report
                </a>


                <a href="distributor.jsp"
                   class="report-link">
                    Distributors
                </a>


            </div>

        </div>


    </div>


</body>

</html>
