<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<%
    String fromDate = request.getParameter("from_date");
    String toDate = request.getParameter("to_date");

    if (fromDate == null || fromDate.trim().isEmpty()) {
        fromDate = java.time.LocalDate.now().toString();
    }

    if (toDate == null || toDate.trim().isEmpty()) {
        toDate = java.time.LocalDate.now().toString();
    }

    double totalExpense = 0;
    int totalRecords = 0;
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Expense Report - Smart Dairy</title>

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

        .btn {
            text-decoration: none;
            color: white;
            background: #607d8b;
            padding: 10px 18px;
            border-radius: 6px;
            margin-left: 8px;
        }

        .container {
            width: 92%;
            margin: 30px auto;
        }

        .filter-box {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 25px;
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

        input {
            width: 100%;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        .filter-btn {
            padding: 11px 25px;
            border: none;
            border-radius: 6px;
            background: #1565c0;
            color: white;
            cursor: pointer;
            font-size: 15px;
        }

        .summary {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 25px;
            display: flex;
            gap: 50px;
        }

        .summary-item h3 {
            margin: 0 0 8px;
            color: #555;
        }

        .summary-value {
            font-size: 28px;
            font-weight: bold;
            color: #e65100;
        }

        .table-box {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #243447;
            color: white;
            padding: 12px;
            text-align: left;
        }

        td {
            padding: 11px;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .print-btn {
            background: #2e7d32;
        }

        @media print {

            .no-print {
                display: none;
            }

            body {
                background: white;
            }

            .container {
                width: 100%;
            }

            .filter-box {
                box-shadow: none;
            }

            .summary,
            .table-box {
                box-shadow: none;
            }
        }

        @media (max-width: 700px) {

            .filter-form {
                grid-template-columns: 1fr;
            }

            .summary {
                flex-direction: column;
                gap: 20px;
            }

            table {
                font-size: 13px;
            }

        }

    </style>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>


<body>


    <div class="header">

        <h1>Smart Dairy - Expense Report</h1>

        <div class="no-print">

            <a href="reports.jsp" class="btn">
                ← Reports
            </a>

            <a href="expense.jsp" class="btn">
                Expenses
            </a>

        </div>

    </div>


    <div class="container">


        <!-- FILTER -->

        <div class="filter-box no-print">

            <h2>Expense Report Filter</h2>

            <form method="get"
                  action="expense_report.jsp"
                  class="filter-form">


                <div>

                    <label>From Date</label>

                    <input type="date"
                           name="from_date"
                           value="<%= fromDate %>"
                           required>

                </div>


                <div>

                    <label>To Date</label>

                    <input type="date"
                           name="to_date"
                           value="<%= toDate %>"
                           required>

                </div>


                <div>

                    <button type="submit"
                            class="filter-btn">
                        Generate Report
                    </button>

                </div>


            </form>

        </div>


        <%
            try {

                Connection con = DBConnection.getConnection();


                // TOTAL EXPENSE

                String totalSql =
                    "SELECT COALESCE(SUM(amount),0) " +
                    "FROM expenses " +
                    "WHERE expense_date BETWEEN ? AND ?";

                PreparedStatement totalPs =
                    con.prepareStatement(totalSql);

                totalPs.setString(1, fromDate);
                totalPs.setString(2, toDate);

                ResultSet totalRs =
                    totalPs.executeQuery();

                if (totalRs.next()) {
                    totalExpense = totalRs.getDouble(1);
                }

                totalRs.close();
                totalPs.close();


                // TOTAL RECORDS

                String countSql =
                    "SELECT COUNT(*) " +
                    "FROM expenses " +
                    "WHERE expense_date BETWEEN ? AND ?";

                PreparedStatement countPs =
                    con.prepareStatement(countSql);

                countPs.setString(1, fromDate);
                countPs.setString(2, toDate);

                ResultSet countRs =
                    countPs.executeQuery();

                if (countRs.next()) {
                    totalRecords = countRs.getInt(1);
                }

                countRs.close();
                countPs.close();

        %>


        <!-- SUMMARY -->

        <div class="summary">

            <div class="summary-item">

                <h3>Total Expenses</h3>

                <div class="summary-value">
                    Rs. <%= String.format("%.2f", totalExpense) %>
                </div>

            </div>


            <div class="summary-item">

                <h3>Total Records</h3>

                <div class="summary-value">
                    <%= totalRecords %>
                </div>

            </div>


            <div class="summary-item">

                <h3>Report Period</h3>

                <div class="summary-value"
                     style="font-size:20px; color:#243447;">

                    <%= fromDate %>
                    →
                    <%= toDate %>

                </div>

            </div>

        </div>


        <!-- EXPENSE DETAILS -->

        <div class="table-box">

            <div style="display:flex;
                        justify-content:space-between;
                        align-items:center;">

                <h2>Expense Details</h2>

                <button onclick="window.print()"
                        class="btn print-btn no-print"
                        style="border:none;
                               cursor:pointer;">
                    Print Report
                </button>

            </div>


            <table>

                <thead>

                    <tr>

                        <th>ID</th>
                        <th>Date</th>
                        <th>Category</th>
                        <th>Amount</th>
                        <th>Payment Method</th>
                        <th>Description</th>

                    </tr>

                </thead>


                <tbody>

                <%
                    String detailSql =
                        "SELECT * FROM expenses " +
                        "WHERE expense_date BETWEEN ? AND ? " +
                        "ORDER BY expense_date DESC, id DESC";

                    PreparedStatement detailPs =
                        con.prepareStatement(detailSql);

                    detailPs.setString(1, fromDate);
                    detailPs.setString(2, toDate);

                    ResultSet detailRs =
                        detailPs.executeQuery();

                    while (detailRs.next()) {
                %>

                    <tr>

                        <td>
                            <%= detailRs.getInt("id") %>
                        </td>

                        <td>
                            <%= detailRs.getDate("expense_date") %>
                        </td>

                        <td>
                            <%= detailRs.getString("category") %>
                        </td>

                        <td>
                            Rs.
                            <%= String.format("%.2f",
                                detailRs.getDouble("amount")) %>
                        </td>

                        <td>
                            <%= detailRs.getString("payment_method") %>
                        </td>

                        <td>
                            <%= detailRs.getString("description") == null
                                ? ""
                                : detailRs.getString("description") %>
                        </td>

                    </tr>

                <%
                    }

                    detailRs.close();
                    detailPs.close();
                    con.close();

                %>

                </tbody>

            </table>

        </div>


        <%
            } catch (Exception e) {

                e.printStackTrace();
        %>

            <div class="table-box">

                <h3>
                    Error loading expense report.
                </h3>

                <p>
                    <%= e.getMessage() %>
                </p>

            </div>

        <%
            }
        %>


    </div>

</body>

</html>