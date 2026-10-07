<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Invoice Management - Smart Dairy</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f7fb;
            color: #333;
        }

        .header {
            background: #6f1d3b;
            color: white;
            padding: 20px 35px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            margin: 0;
            font-size: 26px;
        }

        .header a {
            color: white;
            text-decoration: none;
            background: #ffffff22;
            padding: 10px 18px;
            border-radius: 6px;
        }

        .container {
            max-width: 1400px;
            margin: auto;
            padding: 30px;
        }

        .page-title {
            margin-bottom: 25px;
        }

        .page-title h2 {
            margin: 0;
            color: #6f1d3b;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.08);
            margin-bottom: 25px;
        }

        .card h3 {
            margin-top: 0;
            color: #6f1d3b;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 18px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-weight: bold;
            margin-bottom: 7px;
        }

        input,
        select,
        textarea {
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        textarea {
            resize: vertical;
            min-height: 60px;
        }

        .full-width {
            grid-column: span 2;
        }

        .btn {
            background: #6f1d3b;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            margin-top: 20px;
        }

        .btn:hover {
            background: #55152d;
        }

        .message {
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .success {
            background: #d4edda;
            color: #155724;
        }

        .error {
            background: #f8d7da;
            color: #721c24;
        }

        .search-box {
            margin-bottom: 20px;
        }

        .search-box input {
            width: 350px;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1050px;
        }

        th {
            background: #6f1d3b;
            color: white;
            padding: 12px;
            text-align: left;
        }

        td {
            padding: 11px;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background: #f9f9f9;
        }

        .delete-btn {
            background: #dc2626;
            color: white;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 5px;
        }

        .view-btn {
            background: #2563eb;
            color: white;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 5px;
            margin-right: 5px;
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

        .info-box {
            background: #f8f1f4;
            border-left: 4px solid #6f1d3b;
            padding: 12px;
            margin-top: 15px;
        }

        @media (max-width: 800px) {

            .form-grid {
                grid-template-columns: 1fr;
            }

            .full-width {
                grid-column: span 1;
            }

            .search-box input {
                width: 100%;
            }

            .container {
                padding: 15px;
            }

        }

    </style>

</head>

<body>


<div class="header">

    <h1>Smart Dairy</h1>

    <a href="dashboard.jsp">Back to Dashboard</a>

</div>


<div class="container">


    <div class="page-title">

        <h2>Invoice & Billing</h2>

        <p>
            Generate invoices from existing customer orders.
        </p>

    </div>


    <%
        String success = request.getParameter("success");
        String deleted = request.getParameter("deleted");
        String error = request.getParameter("error");

        if ("true".equals(success)) {
    %>

        <div class="message success">
            Invoice generated successfully.
        </div>

    <%
        }

        if ("true".equals(deleted)) {
    %>

        <div class="message success">
            Invoice deleted successfully.
        </div>

    <%
        }

        if ("true".equals(error)) {
    %>

        <div class="message error">
            Unable to process invoice.
        </div>

    <%
        }

        if ("order".equals(error)) {
    %>

        <div class="message error">
            Selected order was not found.
        </div>

    <%
        }

        if ("exists".equals(error)) {
    %>

        <div class="message error">
            An invoice already exists for this order.
        </div>

    <%
        }
    %>


    <!-- GENERATE INVOICE -->

    <div class="card">

        <h3>Generate New Invoice</h3>


        <form action="InvoiceServlet" method="post">


            <div class="form-grid">


                <div class="form-group">

                    <label>Select Order</label>

                    <select name="order_id" required>

                        <option value="">
                            Select Order
                        </option>

                        <%

                            Connection con = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;

                            try {

                                con = DBConnection.getConnection();

                                String orderSql =
                                    "SELECT o.id, "
                                    + "o.order_date, "
                                    + "o.total_amount, "
                                    + "o.payment_status, "
                                    + "c.name AS customer_name "
                                    + "FROM orders o "
                                    + "JOIN customers c "
                                    + "ON o.customer_id = c.id "
                                    + "WHERE o.status <> 'CANCELLED' "
                                    + "ORDER BY o.id DESC";

                                ps =
                                    con.prepareStatement(orderSql);

                                rs =
                                    ps.executeQuery();

                                while (rs.next()) {

                        %>

                            <option value="<%= rs.getInt("id") %>">

                                Order #<%= rs.getInt("id") %>
                                -
                                <%= rs.getString("customer_name") %>
                                -
                                Rs.
                                <%= rs.getDouble("total_amount") %>
                                -
                                <%= rs.getString("payment_status") %>

                            </option>

                        <%

                                }

                                rs.close();
                                ps.close();

                            } catch (Exception e) {

                                e.printStackTrace();

                        %>

                            <option value="">
                                Unable to load orders
                            </option>

                        <%

                            }

                        %>

                    </select>

                </div>


                <div class="form-group">

                    <label>Invoice Date</label>

                    <input type="date"
                           id="invoice_date"
                           name="invoice_date"
                           required>

                </div>


                <div class="form-group full-width">

                    <label>Remarks</label>

                    <textarea name="remarks"
                              placeholder="Optional invoice remarks"></textarea>

                </div>


            </div>


            <div class="info-box">

                Total amount, paid amount, pending amount and
                payment status will be calculated automatically
                from the selected order and payment records.

            </div>


            <button type="submit" class="btn">
                Generate Invoice
            </button>


        </form>

    </div>


    <!-- INVOICE HISTORY -->

    <div class="card">

        <h3>Invoice History</h3>


        <div class="search-box">

            <input type="text"
                   id="searchInput"
                   placeholder="Search invoice, customer, order or status..."
                   onkeyup="searchTable()">

        </div>


        <div class="table-container">

            <table id="invoiceTable">

                <thead>

                    <tr>

                        <th>ID</th>
                        <th>Invoice No.</th>
                        <th>Order</th>
                        <th>Customer</th>
                        <th>Date</th>
                        <th>Total</th>
                        <th>Paid</th>
                        <th>Pending</th>
                        <th>Status</th>
                        <th>Remarks</th>
                        <th>Action</th>

                    </tr>

                </thead>


                <tbody>

                <%

                    try {

                        String invoiceSql =
                            "SELECT i.id, "
                            + "i.invoice_number, "
                            + "i.order_id, "
                            + "c.name AS customer_name, "
                            + "i.invoice_date, "
                            + "i.total_amount, "
                            + "i.paid_amount, "
                            + "i.pending_amount, "
                            + "i.payment_status, "
                            + "i.remarks "
                            + "FROM invoices i "
                            + "JOIN customers c "
                            + "ON i.customer_id = c.id "
                            + "ORDER BY i.id DESC";

                        ps =
                            con.prepareStatement(invoiceSql);

                        rs =
                            ps.executeQuery();

                        while (rs.next()) {

                            String paymentStatus =
                                rs.getString("payment_status");

                            String statusClass = "pending";

                            if ("PAID".equals(paymentStatus)) {

                                statusClass = "paid";

                            } else if ("PARTIAL".equals(paymentStatus)) {

                                statusClass = "partial";

                            }

                %>

                    <tr>

                        <td>
                            <%= rs.getInt("id") %>
                        </td>

                        <td>
                            <%= rs.getString("invoice_number") %>
                        </td>

                        <td>
                            #<%= rs.getInt("order_id") %>
                        </td>

                        <td>
                            <%= rs.getString("customer_name") %>
                        </td>

                        <td>
                            <%= rs.getDate("invoice_date") %>
                        </td>

                        <td>
                            Rs.
                            <%= rs.getDouble("total_amount") %>
                        </td>

                        <td>
                            Rs.
                            <%= rs.getDouble("paid_amount") %>
                        </td>

                        <td>
                            Rs.
                            <%= rs.getDouble("pending_amount") %>
                        </td>

                        <td class="<%= statusClass %>">

                            <%= paymentStatus %>

                        </td>

                        <td>

                            <%= rs.getString("remarks") == null
                                ? "-"
                                : rs.getString("remarks") %>

                        </td>

                        <td>

                            <a class="view-btn"
                               href="invoice_view.jsp?id=<%= rs.getInt("id") %>">

                                View

                            </a>

                            <a class="delete-btn"
                               href="InvoiceDeleteServlet?id=<%= rs.getInt("id") %>"
                               onclick="return confirm('Are you sure you want to delete this invoice?');">

                                Delete

                            </a>

                        </td>

                    </tr>

                <%

                        }

                        rs.close();
                        ps.close();
                        con.close();

                    } catch (Exception e) {

                        e.printStackTrace();

                %>

                    <tr>

                        <td colspan="11">

                            Unable to load invoice records.

                        </td>

                    </tr>

                <%

                    }

                %>

                </tbody>

            </table>

        </div>

    </div>


</div>


<script>

    // Today's date

    const today = new Date();

    const year = today.getFullYear();

    const month =
        String(today.getMonth() + 1).padStart(2, '0');

    const day =
        String(today.getDate()).padStart(2, '0');

    document.getElementById("invoice_date").value =
        year + "-" + month + "-" + day;


    // Search invoice table

    function searchTable() {

        const input =
            document.getElementById("searchInput");

        const filter =
            input.value.toLowerCase();

        const table =
            document.getElementById("invoiceTable");

        const rows =
            table.getElementsByTagName("tr");


        for (let i = 1; i < rows.length; i++) {

            const text =
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