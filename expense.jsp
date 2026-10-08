<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Expenses - Smart Dairy</title>

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

        .card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        .total-card {
            background: #fff3e0;
            border-left: 6px solid #ef6c00;
        }

        .total-card h2 {
            margin: 0 0 10px;
        }

        .total-amount {
            font-size: 30px;
            font-weight: bold;
            color: #e65100;
        }

        h2 {
            color: #243447;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .full {
            grid-column: 1 / 3;
        }

        label {
            font-weight: bold;
            margin-bottom: 7px;
        }

        input,
        select,
        textarea {
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        textarea {
            min-height: 80px;
            resize: vertical;
        }

        .save-btn {
            margin-top: 20px;
            padding: 12px 25px;
            border: none;
            background: #2e7d32;
            color: white;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        .save-btn:hover {
            background: #1b5e20;
        }

        .message {
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .success {
            background: #e8f5e9;
            color: #2e7d32;
        }

        .error {
            background: #ffebee;
            color: #c62828;
        }

        .search-box {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
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

        .edit-btn {
            background: #1565c0;
            color: white;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 5px;
            margin-right: 5px;
        }

        .delete-btn {
            background: #c62828;
            color: white;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 5px;
        }

        @media (max-width: 700px) {

            .form-grid {
                grid-template-columns: 1fr;
            }

            .full {
                grid-column: 1;
            }

            table {
                font-size: 13px;
            }

            th,
            td {
                padding: 7px;
            }

        }

    </style>

</head>


<body>


    <div class="header">

        <h1>Smart Dairy - Expense Management</h1>

        <a href="dashboard.jsp" class="back-btn">
            ← Dashboard
        </a>

    </div>


    <div class="container">


        <%
            String success = request.getParameter("success");
            String updated = request.getParameter("updated");
            String deleted = request.getParameter("deleted");
            String error = request.getParameter("error");

            if ("true".equals(success)) {
        %>

            <div class="message success">
                Expense added successfully.
            </div>

        <%
            }

            if ("true".equals(updated)) {
        %>

            <div class="message success">
                Expense updated successfully.
            </div>

        <%
            }

            if ("true".equals(deleted)) {
        %>

            <div class="message success">
                Expense deleted successfully.
            </div>

        <%
            }

            if ("true".equals(error)) {
        %>

            <div class="message error">
                Something went wrong. Please try again.
            </div>

        <%
            }

            if ("amount".equals(error)) {
        %>

            <div class="message error">
                Amount must be greater than 0.
            </div>

        <%
            }
        %>


        <!-- TOTAL EXPENSE -->

        <div class="card total-card">

            <h2>Total Expenses</h2>

            <%
                double totalExpenses = 0;

                try {

                    Connection con = DBConnection.getConnection();

                    String sql =
                        "SELECT COALESCE(SUM(amount),0) FROM expenses";

                    PreparedStatement ps =
                        con.prepareStatement(sql);

                    ResultSet rs =
                        ps.executeQuery();

                    if (rs.next()) {
                        totalExpenses = rs.getDouble(1);
                    }

                    rs.close();
                    ps.close();
                    con.close();

                } catch (Exception e) {

                    e.printStackTrace();
                }
            %>

            <div class="total-amount">
                Rs. <%= String.format("%.2f", totalExpenses) %>
            </div>

        </div>


        <!-- ADD EXPENSE -->

        <div class="card">

            <h2>Add New Expense</h2>

            <form action="ExpenseServlet" method="post">

                <div class="form-grid">


                    <div class="form-group">

                        <label>Expense Date</label>

                        <input type="date"
                               name="expense_date"
                               id="expense_date"
                               required>

                    </div>


                    <div class="form-group">

                        <label>Category</label>

                        <select name="category" required>

                            <option value="">Select Category</option>

                            <option value="FEED">Feed</option>

                            <option value="ELECTRICITY">Electricity</option>

                            <option value="TRANSPORT">Transport</option>

                            <option value="SALARY">Salary</option>

                            <option value="MAINTENANCE">Maintenance</option>

                            <option value="PACKAGING">Packaging</option>

                            <option value="EQUIPMENT">Equipment</option>

                            <option value="OTHER">Other</option>

                        </select>

                    </div>


                    <div class="form-group">

                        <label>Amount (Rs.)</label>

                        <input type="number"
                               name="amount"
                               step="0.01"
                               min="0.01"
                               placeholder="Enter amount"
                               required>

                    </div>


                    <div class="form-group">

                        <label>Payment Method</label>

                        <select name="payment_method" required>

                            <option value="">Select Method</option>

                            <option value="CASH">Cash</option>

                            <option value="UPI">UPI</option>

                            <option value="BANK">Bank</option>

                            <option value="OTHER">Other</option>

                        </select>

                    </div>


                    <div class="form-group full">

                        <label>Description</label>

                        <textarea name="description"
                                  placeholder="Enter expense description"></textarea>

                    </div>


                </div>


                <button type="submit" class="save-btn">
                    Save Expense
                </button>

            </form>

        </div>


        <!-- EXPENSE HISTORY -->

        <div class="card">

            <h2>Expense History</h2>

            <input type="text"
                   id="searchInput"
                   class="search-box"
                   placeholder="Search by category, date, payment method or description...">


            <table id="expenseTable">

                <thead>

                    <tr>

                        <th>ID</th>
                        <th>Date</th>
                        <th>Category</th>
                        <th>Amount</th>
                        <th>Payment Method</th>
                        <th>Description</th>
                        <th>Action</th>

                    </tr>

                </thead>


                <tbody>

                <%
                    try {

                        Connection con = DBConnection.getConnection();

                        String sql =
                            "SELECT * FROM expenses ORDER BY id DESC";

                        PreparedStatement ps =
                            con.prepareStatement(sql);

                        ResultSet rs =
                            ps.executeQuery();

                        while (rs.next()) {
                %>

                    <tr>

                        <td>
                            <%= rs.getInt("id") %>
                        </td>

                        <td>
                            <%= rs.getDate("expense_date") %>
                        </td>

                        <td>
                            <%= rs.getString("category") %>
                        </td>

                        <td>
                            Rs. <%= rs.getDouble("amount") %>
                        </td>

                        <td>
                            <%= rs.getString("payment_method") %>
                        </td>

                        <td>
                            <%= rs.getString("description") == null
                                ? ""
                                : rs.getString("description") %>
                        </td>

                        <td>

                            <a class="edit-btn"
                               href="expense_edit.jsp?id=<%= rs.getInt("id") %>">
                                Edit
                            </a>

                            <a class="delete-btn"
                               href="ExpenseDeleteServlet?id=<%= rs.getInt("id") %>"
                               onclick="return confirm('Are you sure you want to delete this expense?');">
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

                        <td colspan="7">
                            Error loading expense records.
                        </td>

                    </tr>

                <%
                    }
                %>

                </tbody>

            </table>

        </div>


    </div>


    <script>

        // Set today's date automatically

        document.getElementById("expense_date").value =
            new Date().toISOString().split("T")[0];


        // Search functionality

        document.getElementById("searchInput")
        .addEventListener("keyup", function() {

            let searchValue =
                this.value.toLowerCase();

            let rows =
                document.querySelectorAll("#expenseTable tbody tr");

            rows.forEach(function(row) {

                let text =
                    row.innerText.toLowerCase();

                if (text.includes(searchValue)) {

                    row.style.display = "";

                } else {

                    row.style.display = "none";

                }

            });

        });

    </script>


</body>

</html>