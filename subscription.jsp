<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Subscription Management - Smart Dairy</title>

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
            padding: 30px;
            max-width: 1400px;
            margin: auto;
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
            grid-template-columns: repeat(3, 1fr);
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
            min-height: 42px;
        }

        .full-width {
            grid-column: span 3;
        }

        .btn {
            background: #6f1d3b;
            color: white;
            border: none;
            padding: 12px 22px;
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
            min-width: 1100px;
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

        .edit-btn {
            background: #2563eb;
            color: white;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 5px;
            margin-right: 5px;
        }

        .delete-btn {
            background: #dc2626;
            color: white;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 5px;
        }

        .status-active {
            color: green;
            font-weight: bold;
        }

        .status-paused {
            color: #d97706;
            font-weight: bold;
        }

        .status-cancelled {
            color: red;
            font-weight: bold;
        }

        @media (max-width: 900px) {

            .form-grid {
                grid-template-columns: 1fr;
            }

            .full-width {
                grid-column: span 1;
            }

            .container {
                padding: 15px;
            }

            .search-box input {
                width: 100%;
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
        <h2>Subscription Management</h2>
        <p>Manage regular milk and dairy product subscriptions.</p>
    </div>


    <%
        String success = request.getParameter("success");
        String updated = request.getParameter("updated");
        String deleted = request.getParameter("deleted");
        String error = request.getParameter("error");

        if ("true".equals(success)) {
    %>

        <div class="message success">
            Subscription added successfully.
        </div>

    <%
        }

        if ("true".equals(updated)) {
    %>

        <div class="message success">
            Subscription updated successfully.
        </div>

    <%
        }

        if ("true".equals(deleted)) {
    %>

        <div class="message success">
            Subscription deleted successfully.
        </div>

    <%
        }

        if ("true".equals(error)) {
    %>

        <div class="message error">
            Unable to process subscription. Please check the details.
        </div>

    <%
        }
    %>


    <!-- ADD SUBSCRIPTION -->

    <div class="card">

        <h3>Add New Subscription</h3>

        <form action="SubscriptionServlet" method="post">

            <div class="form-grid">

                <div class="form-group">

                    <label>Customer</label>

                    <select name="customer_id" required>

                        <option value="">Select Customer</option>

                        <%
                            Connection con = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;

                            try {

                                con = DBConnection.getConnection();

                                String customerSql =
                                    "SELECT id, name, mobile "
                                    + "FROM customers "
                                    + "WHERE status = 'ACTIVE' "
                                    + "ORDER BY name";

                                ps = con.prepareStatement(customerSql);
                                rs = ps.executeQuery();

                                while (rs.next()) {
                        %>

                            <option value="<%= rs.getInt("id") %>">
                                <%= rs.getString("name") %>
                                -
                                <%= rs.getString("mobile") %>
                            </option>

                        <%
                                }

                                rs.close();
                                ps.close();

                            } catch (Exception e) {

                                e.printStackTrace();

                            }
                        %>

                    </select>

                </div>


                <div class="form-group">

                    <label>Product</label>

                    <select name="product_id" required>

                        <option value="">Select Product</option>

                        <%
                            try {

                                String productSql =
                                    "SELECT id, product_name, unit, selling_price "
                                    + "FROM products "
                                    + "WHERE status = 'ACTIVE' "
                                    + "ORDER BY product_name";

                                ps = con.prepareStatement(productSql);
                                rs = ps.executeQuery();

                                while (rs.next()) {
                        %>

                            <option value="<%= rs.getInt("id") %>">

                                <%= rs.getString("product_name") %>
                                -
                                Rs. <%= rs.getDouble("selling_price") %>
                                /
                                <%= rs.getString("unit") %>

                            </option>

                        <%
                                }

                                rs.close();
                                ps.close();

                            } catch (Exception e) {

                                e.printStackTrace();

                            }
                        %>

                    </select>

                </div>


                <div class="form-group">

                    <label>Quantity</label>

                    <input type="number"
                           name="quantity"
                           step="0.01"
                           min="0.01"
                           placeholder="Example: 1"
                           required>

                </div>


                <div class="form-group">

                    <label>Shift</label>

                    <select name="shift" required>

                        <option value="">Select Shift</option>
                        <option value="MORNING">Morning</option>
                        <option value="EVENING">Evening</option>

                    </select>

                </div>


                <div class="form-group">

                    <label>Start Date</label>

                    <input type="date"
                           id="start_date"
                           name="start_date"
                           required>

                </div>


                <div class="form-group">

                    <label>End Date</label>

                    <input type="date"
                           id="end_date"
                           name="end_date">

                </div>


                <div class="form-group">

                    <label>Status</label>

                    <select name="status" required>

                        <option value="ACTIVE">Active</option>
                        <option value="PAUSED">Paused</option>
                        <option value="COMPLETED">Completed</option>
                        <option value="CANCELLED">Cancelled</option>

                    </select>

                </div>


                <div class="form-group full-width">

                    <label>Remarks</label>

                    <textarea name="remarks"
                              placeholder="Optional remarks"></textarea>

                </div>

            </div>


            <button type="submit" class="btn">
                Add Subscription
            </button>

        </form>

    </div>


    <!-- SEARCH -->

    <div class="card">

        <h3>Subscription History</h3>

        <div class="search-box">

            <input type="text"
                   id="searchInput"
                   placeholder="Search customer, product, shift or status..."
                   onkeyup="searchTable()">

        </div>


        <div class="table-container">

            <table id="subscriptionTable">

                <thead>

                    <tr>

                        <th>ID</th>
                        <th>Customer</th>
                        <th>Mobile</th>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th>Shift</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Status</th>
                        <th>Remarks</th>
                        <th>Actions</th>

                    </tr>

                </thead>

                <tbody>

                <%
                    try {

                        String subscriptionSql =
                            "SELECT s.id, "
                            + "c.name AS customer_name, "
                            + "c.mobile, "
                            + "p.product_name, "
                            + "p.unit, "
                            + "s.quantity, "
                            + "s.shift, "
                            + "s.start_date, "
                            + "s.end_date, "
                            + "s.status, "
                            + "s.remarks "
                            + "FROM subscriptions s "
                            + "JOIN customers c "
                            + "ON s.customer_id = c.id "
                            + "JOIN products p "
                            + "ON s.product_id = p.id "
                            + "ORDER BY s.id DESC";

                        ps = con.prepareStatement(subscriptionSql);
                        rs = ps.executeQuery();

                        while (rs.next()) {

                            String currentStatus =
                                rs.getString("status");

                            String statusClass = "";

                            if ("ACTIVE".equals(currentStatus)) {
                                statusClass = "status-active";
                            } else if ("PAUSED".equals(currentStatus)) {
                                statusClass = "status-paused";
                            } else if ("CANCELLED".equals(currentStatus)) {
                                statusClass = "status-cancelled";
                            }
                %>

                    <tr>

                        <td>
                            <%= rs.getInt("id") %>
                        </td>

                        <td>
                            <%= rs.getString("customer_name") %>
                        </td>

                        <td>
                            <%= rs.getString("mobile") %>
                        </td>

                        <td>
                            <%= rs.getString("product_name") %>
                        </td>

                        <td>
                            <%= rs.getDouble("quantity") %>
                            <%= rs.getString("unit") %>
                        </td>

                        <td>
                            <%= rs.getString("shift") %>
                        </td>

                        <td>
                            <%= rs.getDate("start_date") %>
                        </td>

                        <td>
                            <%= rs.getDate("end_date") == null
                                ? "-"
                                : rs.getDate("end_date") %>
                        </td>

                        <td class="<%= statusClass %>">
                            <%= rs.getString("status") %>
                        </td>

                        <td>
                            <%= rs.getString("remarks") == null
                                ? "-"
                                : rs.getString("remarks") %>
                        </td>

                        <td>

                            <a class="edit-btn"
                               href="subscription_edit.jsp?id=<%= rs.getInt("id") %>">
                                Edit
                            </a>

                            <a class="delete-btn"
                               href="SubscriptionDeleteServlet?id=<%= rs.getInt("id") %>"
                               onclick="return confirm('Are you sure you want to delete this subscription?');">
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
                            Unable to load subscription records.
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

    // Automatically set today's date

    const today = new Date();

    const year = today.getFullYear();

    const month = String(today.getMonth() + 1).padStart(2, '0');

    const day = String(today.getDate()).padStart(2, '0');

    const todayString = year + "-" + month + "-" + day;

    document.getElementById("start_date").value = todayString;


    // Search subscription table

    function searchTable() {

        const input =
            document.getElementById("searchInput");

        const filter =
            input.value.toLowerCase();

        const table =
            document.getElementById("subscriptionTable");

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