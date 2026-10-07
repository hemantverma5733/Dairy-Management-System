<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<%
    String idText = request.getParameter("id");

    int id = 0;
    String expenseDate = "";
    String category = "";
    String amount = "";
    String description = "";
    String paymentMethod = "";

    try {

        id = Integer.parseInt(idText);

        Connection con = DBConnection.getConnection();

        String sql = "SELECT * FROM expenses WHERE id = ?";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            expenseDate = rs.getString("expense_date");
            category = rs.getString("category");
            amount = rs.getString("amount");
            description = rs.getString("description");
            paymentMethod = rs.getString("payment_method");

        } else {

            out.println("<h2>Expense not found</h2>");
            return;
        }

        rs.close();
        ps.close();
        con.close();

    } catch (Exception e) {

        out.println("<h2>Error loading expense</h2>");
        out.println("<p>" + e.getMessage() + "</p>");
        return;
    }
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Edit Expense - Smart Dairy</title>

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
            font-size: 26px;
        }

        .back-btn {
            text-decoration: none;
            color: white;
            background: #607d8b;
            padding: 10px 18px;
            border-radius: 6px;
        }

        .container {
            width: 70%;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        h2 {
            margin-top: 0;
            color: #243447;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .full {
            grid-column: 1 / 3;
        }

        label {
            margin-bottom: 7px;
            font-weight: bold;
            color: #444;
        }

        input,
        select,
        textarea {
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        textarea {
            resize: vertical;
            min-height: 90px;
        }

        .update-btn {
            margin-top: 25px;
            width: 100%;
            padding: 13px;
            background: #2e7d32;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        .update-btn:hover {
            background: #1b5e20;
        }

        .error {
            background: #ffebee;
            color: #c62828;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        @media (max-width: 700px) {

            .container {
                width: 92%;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .full {
                grid-column: 1;
            }
        }

    </style>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>

    <div class="header">

        <h1>Smart Dairy</h1>

        <a href="expense.jsp" class="back-btn">
            ← Back to Expenses
        </a>

    </div>


    <div class="container">

        <h2>Edit Expense</h2>

        <%
            String error = request.getParameter("error");

            if ("amount".equals(error)) {
        %>

            <div class="error">
                Amount must be greater than 0.
            </div>

        <%
            }
        %>


        <form action="ExpenseUpdateServlet" method="post">

            <input type="hidden"
                   name="id"
                   value="<%= id %>">


            <div class="form-grid">


                <div class="form-group">

                    <label>Expense Date</label>

                    <input type="date"
                           name="expense_date"
                           value="<%= expenseDate %>"
                           required>

                </div>


                <div class="form-group">

                    <label>Category</label>

                    <select name="category" required>

                        <option value="FEED"
                            <%= "FEED".equals(category) ? "selected" : "" %>>
                            Feed
                        </option>

                        <option value="ELECTRICITY"
                            <%= "ELECTRICITY".equals(category) ? "selected" : "" %>>
                            Electricity
                        </option>

                        <option value="TRANSPORT"
                            <%= "TRANSPORT".equals(category) ? "selected" : "" %>>
                            Transport
                        </option>

                        <option value="SALARY"
                            <%= "SALARY".equals(category) ? "selected" : "" %>>
                            Salary
                        </option>

                        <option value="MAINTENANCE"
                            <%= "MAINTENANCE".equals(category) ? "selected" : "" %>>
                            Maintenance
                        </option>

                        <option value="PACKAGING"
                            <%= "PACKAGING".equals(category) ? "selected" : "" %>>
                            Packaging
                        </option>

                        <option value="EQUIPMENT"
                            <%= "EQUIPMENT".equals(category) ? "selected" : "" %>>
                            Equipment
                        </option>

                        <option value="OTHER"
                            <%= "OTHER".equals(category) ? "selected" : "" %>>
                            Other
                        </option>

                    </select>

                </div>


                <div class="form-group">

                    <label>Amount (Rs.)</label>

                    <input type="number"
                           name="amount"
                           step="0.01"
                           min="0.01"
                           value="<%= amount %>"
                           required>

                </div>


                <div class="form-group">

                    <label>Payment Method</label>

                    <select name="payment_method" required>

                        <option value="CASH"
                            <%= "CASH".equals(paymentMethod) ? "selected" : "" %>>
                            Cash
                        </option>

                        <option value="UPI"
                            <%= "UPI".equals(paymentMethod) ? "selected" : "" %>>
                            UPI
                        </option>

                        <option value="BANK"
                            <%= "BANK".equals(paymentMethod) ? "selected" : "" %>>
                            Bank
                        </option>

                        <option value="OTHER"
                            <%= "OTHER".equals(paymentMethod) ? "selected" : "" %>>
                            Other
                        </option>

                    </select>

                </div>


                <div class="form-group full">

                    <label>Description</label>

                    <textarea name="description"
                              placeholder="Enter expense description"><%= description == null ? "" : description %></textarea>

                </div>


            </div>


            <button type="submit" class="update-btn">
                Update Expense
            </button>

        </form>

    </div>

</body>

</html>