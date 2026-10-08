<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>View Invoice - Smart Dairy</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f4f6;
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

        .invoice-container {
            max-width: 950px;
            margin: 35px auto;
            background: white;
            padding: 40px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.10);
        }

        .invoice-header {
            display: flex;
            justify-content: space-between;
            border-bottom: 2px solid #6f1d3b;
            padding-bottom: 20px;
            margin-bottom: 25px;
        }

        .company h1 {
            color: #6f1d3b;
            margin: 0 0 8px 0;
        }

        .company p {
            margin: 4px 0;
            color: #666;
        }

        .invoice-title {
            text-align: right;
        }

        .invoice-title h2 {
            margin: 0;
            color: #6f1d3b;
        }

        .invoice-title p {
            margin: 6px 0;
        }

        .customer-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .box h4 {
            margin: 0 0 8px 0;
            color: #6f1d3b;
        }

        .box p {
            margin: 5px 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th {
            background: #6f1d3b;
            color: white;
            padding: 12px;
            text-align: left;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }

        .amount-section {
            width: 350px;
            margin-left: auto;
            margin-top: 25px;
        }

        .amount-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
        }

        .grand-total {
            border-top: 2px solid #6f1d3b;
            font-size: 18px;
            font-weight: bold;
            padding-top: 12px;
        }

        .paid {
            color: green;
            font-weight: bold;
        }

        .partial {
            color: #d97706;
            font-weight: bold;
        }

        .pending {
            color: red;
            font-weight: bold;
        }

        .remarks {
            margin-top: 30px;
            padding: 15px;
            background: #f8f1f4;
            border-left: 4px solid #6f1d3b;
        }

        .actions {
            text-align: center;
            margin: 30px auto;
        }

        .btn {
            display: inline-block;
            padding: 11px 20px;
            border-radius: 6px;
            text-decoration: none;
            color: white;
            border: none;
            cursor: pointer;
            margin: 5px;
            font-size: 14px;
        }

        .print-btn {
            background: #6f1d3b;
        }

        .back-btn {
            background: #555;
        }

        .error {
            max-width: 700px;
            margin: 50px auto;
            background: #f8d7da;
            color: #721c24;
            padding: 20px;
            border-radius: 8px;
        }

        @media print {

            .topbar,
            .actions {
                display: none;
            }

            body {
                background: white;
            }

            .invoice-container {
                box-shadow: none;
                margin: 0;
                max-width: 100%;
            }

        }

        @media (max-width: 700px) {

            .invoice-container {
                margin: 15px;
                padding: 20px;
            }

            .invoice-header {
                flex-direction: column;
            }

            .invoice-title {
                text-align: left;
                margin-top: 20px;
            }

            .customer-section {
                grid-template-columns: 1fr;
            }

            .amount-section {
                width: 100%;
            }

        }

    </style>

</head>

<body>


<div class="topbar">

    <h2>Smart Dairy</h2>

    <a href="invoice.jsp">
        Back to Invoices
    </a>

</div>


<%

    String idText = request.getParameter("id");

    if (idText == null || idText.trim().isEmpty()) {

%>

    <div class="error">

        Invoice ID is missing.

    </div>

<%

    } else {

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            int invoiceId =
                    Integer.parseInt(idText);

            con = DBConnection.getConnection();

            String sql =
                    "SELECT i.id, "
                    + "i.invoice_number, "
                    + "i.order_id, "
                    + "i.invoice_date, "
                    + "i.total_amount, "
                    + "i.paid_amount, "
                    + "i.pending_amount, "
                    + "i.payment_status, "
                    + "i.remarks, "
                    + "c.name AS customer_name, "
                    + "c.mobile AS customer_mobile, "
                    + "c.address AS customer_address "
                    + "FROM invoices i "
                    + "JOIN customers c "
                    + "ON i.customer_id = c.id "
                    + "WHERE i.id = ?";

            ps = con.prepareStatement(sql);

            ps.setInt(1, invoiceId);

            rs = ps.executeQuery();

            if (rs.next()) {

%>


<div class="invoice-container">


    <!-- HEADER -->

    <div class="invoice-header">

        <div class="company">

            <h1>Smart Dairy</h1>

            <p>Milk Dairy Management & Distribution System</p>

            <p>Fresh Milk & Dairy Products</p>

        </div>


        <div class="invoice-title">

            <h2>INVOICE</h2>

            <p>
                <strong>
                    <%= rs.getString("invoice_number") %>
                </strong>
            </p>

            <p>
                Date:
                <%= rs.getDate("invoice_date") %>
            </p>

        </div>

    </div>


    <!-- CUSTOMER DETAILS -->

    <div class="customer-section">


        <div class="box">

            <h4>Bill To</h4>

            <p>
                <strong>
                    <%= rs.getString("customer_name") %>
                </strong>
            </p>

            <p>
                Mobile:
                <%= rs.getString("customer_mobile") %>
            </p>

            <p>
                Address:
                <%= rs.getString("customer_address") == null
                    ? "-"
                    : rs.getString("customer_address") %>
            </p>

        </div>


        <div class="box">

            <h4>Order Details</h4>

            <p>
                Order ID:
                <strong>
                    #<%= rs.getInt("order_id") %>
                </strong>
            </p>

            <p>
                Invoice ID:
                #<%= rs.getInt("id") %>
            </p>

            <p>
                Payment Status:
                <strong>
                    <%= rs.getString("payment_status") %>
                </strong>
            </p>

        </div>

    </div>


    <!-- ORDER ITEMS -->

    <table>

        <thead>

            <tr>

                <th>Product</th>
                <th>Quantity</th>
                <th>Unit Price</th>
                <th>Total</th>

            </tr>

        </thead>


        <tbody>

        <%

            PreparedStatement itemPs = null;
            ResultSet itemRs = null;

            try {

                String itemSql =
                    "SELECT p.product_name, "
                    + "oi.quantity, "
                    + "oi.price, "
                    + "oi.total "
                    + "FROM order_items oi "
                    + "JOIN products p "
                    + "ON oi.product_id = p.id "
                    + "WHERE oi.order_id = ?";

                itemPs =
                    con.prepareStatement(itemSql);

                itemPs.setInt(
                    1,
                    rs.getInt("order_id")
                );

                itemRs =
                    itemPs.executeQuery();

                while (itemRs.next()) {

        %>

            <tr>

                <td>
                    <%= itemRs.getString("product_name") %>
                </td>

                <td>
                    <%= itemRs.getDouble("quantity") %>
                </td>

                <td>
                    Rs.
                    <%= itemRs.getDouble("price") %>
                </td>

                <td>
                    Rs.
                    <%= itemRs.getDouble("total") %>
                </td>

            </tr>

        <%

                }

            } finally {

                if (itemRs != null)
                    itemRs.close();

                if (itemPs != null)
                    itemPs.close();

            }

        %>

        </tbody>

    </table>


    <!-- AMOUNT -->

    <div class="amount-section">

        <div class="amount-row">

            <span>Total Amount</span>

            <span>
                Rs.
                <%= rs.getDouble("total_amount") %>
            </span>

        </div>


        <div class="amount-row">

            <span>Paid Amount</span>

            <span class="paid">

                Rs.
                <%= rs.getDouble("paid_amount") %>

            </span>

        </div>


        <div class="amount-row">

            <span>Pending Amount</span>

            <span class="pending">

                Rs.
                <%= rs.getDouble("pending_amount") %>

            </span>

        </div>


        <div class="amount-row grand-total">

            <span>Balance Due</span>

            <span>
                Rs.
                <%= rs.getDouble("pending_amount") %>
            </span>

        </div>

    </div>


    <!-- REMARKS -->

    <div class="remarks">

        <strong>Remarks:</strong>

        <br>

        <%= rs.getString("remarks") == null
            ? "Thank you for choosing Smart Dairy."
            : rs.getString("remarks") %>

    </div>


</div>


<div class="actions">

    <button
        class="btn print-btn"
        onclick="window.print()">

        Print Invoice

    </button>


    <a
        class="btn back-btn"
        href="invoice.jsp">

        Back to Invoice List

    </a>

</div>


<%

            } else {

%>

        <div class="error">

            Invoice record not found.

        </div>

<%

            }

        } catch (Exception e) {

            e.printStackTrace();

%>

        <div class="error">

            <strong>
                Error loading invoice:
            </strong>

            <br><br>

            <%= e.getMessage() %>

        </div>

<%

        } finally {

            try {
                if (rs != null) rs.close();
            } catch (Exception e) {
            }

            try {
                if (ps != null) ps.close();
            } catch (Exception e) {
            }

            try {
                if (con != null) con.close();
            } catch (Exception e) {
            }

        }

    }

%>


</body>
</html>