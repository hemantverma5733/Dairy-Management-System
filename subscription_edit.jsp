<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Edit Subscription - Smart Dairy</title>

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
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.08);
        }

        h2 {
            color: #6f1d3b;
            margin-top: 0;
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
            min-height: 80px;
        }

        .full-width {
            grid-column: span 2;
        }

        .btn {
            background: #6f1d3b;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            margin-top: 20px;
        }

        .back-btn {
            display: inline-block;
            background: #555;
            color: white;
            text-decoration: none;
            padding: 12px 20px;
            border-radius: 6px;
            margin-left: 10px;
        }

        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        @media (max-width: 700px) {

            .form-grid {
                grid-template-columns: 1fr;
            }

            .full-width {
                grid-column: span 1;
            }

        }

    </style>

</head>

<body>

<div class="header">

    <h1>Smart Dairy</h1>

    <a href="dashboard.jsp">Dashboard</a>

</div>


<div class="container">

    <div class="card">

        <h2>Edit Subscription</h2>

        <%

            String idText = request.getParameter("id");

            if (idText == null || idText.trim().isEmpty()) {

        %>

            <div class="error">
                Subscription ID is missing.
            </div>

            <a href="subscription.jsp" class="back-btn">
                Back to Subscriptions
            </a>

        <%

            } else {

                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {

                    int id = Integer.parseInt(idText);

                    con = DBConnection.getConnection();

                    String sql =
                        "SELECT id, customer_id, product_id, quantity, "
                        + "shift, start_date, end_date, status, remarks "
                        + "FROM subscriptions "
                        + "WHERE id = ?";

                    ps = con.prepareStatement(sql);

                    ps.setInt(1, id);

                    rs = ps.executeQuery();

                    if (rs.next()) {

                        int customerId = rs.getInt("customer_id");
                        int productId = rs.getInt("product_id");

        %>

        <form action="SubscriptionUpdateServlet" method="post">

            <input type="hidden"
                   name="id"
                   value="<%= rs.getInt("id") %>">


            <div class="form-grid">

                <!-- CUSTOMER -->

                <div class="form-group">

                    <label>Customer</label>

                    <select name="customer_id" required>

                        <option value="">
                            Select Customer
                        </option>

                        <%

                            PreparedStatement customerPs = null;
                            ResultSet customerRs = null;

                            try {

                                String customerSql =
                                    "SELECT id, name, mobile "
                                    + "FROM customers "
                                    + "WHERE status = 'ACTIVE' "
                                    + "ORDER BY name";

                                customerPs =
                                    con.prepareStatement(customerSql);

                                customerRs =
                                    customerPs.executeQuery();

                                while (customerRs.next()) {

                                    int currentId =
                                        customerRs.getInt("id");

                        %>

                            <option value="<%= currentId %>"
                                <%= currentId == customerId
                                    ? "selected"
                                    : "" %>>

                                <%= customerRs.getString("name") %>
                                -
                                <%= customerRs.getString("mobile") %>

                            </option>

                        <%

                                }

                            } finally {

                                if (customerRs != null)
                                    customerRs.close();

                                if (customerPs != null)
                                    customerPs.close();

                            }

                        %>

                    </select>

                </div>


                <!-- PRODUCT -->

                <div class="form-group">

                    <label>Product</label>

                    <select name="product_id" required>

                        <option value="">
                            Select Product
                        </option>

                        <%

                            PreparedStatement productPs = null;
                            ResultSet productRs = null;

                            try {

                                String productSql =
                                    "SELECT id, product_name, unit, selling_price "
                                    + "FROM products "
                                    + "WHERE status = 'ACTIVE' "
                                    + "ORDER BY product_name";

                                productPs =
                                    con.prepareStatement(productSql);

                                productRs =
                                    productPs.executeQuery();

                                while (productRs.next()) {

                                    int currentProductId =
                                        productRs.getInt("id");

                        %>

                            <option value="<%= currentProductId %>"
                                <%= currentProductId == productId
                                    ? "selected"
                                    : "" %>>

                                <%= productRs.getString("product_name") %>
                                -
                                Rs.
                                <%= productRs.getDouble("selling_price") %>
                                /
                                <%= productRs.getString("unit") %>

                            </option>

                        <%

                                }

                            } finally {

                                if (productRs != null)
                                    productRs.close();

                                if (productPs != null)
                                    productPs.close();

                            }

                        %>

                    </select>

                </div>


                <!-- QUANTITY -->

                <div class="form-group">

                    <label>Quantity</label>

                    <input type="number"
                           name="quantity"
                           step="0.01"
                           min="0.01"
                           value="<%= rs.getDouble("quantity") %>"
                           required>

                </div>


                <!-- SHIFT -->

                <div class="form-group">

                    <label>Shift</label>

                    <select name="shift" required>

                        <option value="MORNING"
                            <%= "MORNING".equals(rs.getString("shift"))
                                ? "selected"
                                : "" %>>
                            Morning
                        </option>

                        <option value="EVENING"
                            <%= "EVENING".equals(rs.getString("shift"))
                                ? "selected"
                                : "" %>>
                            Evening
                        </option>

                    </select>

                </div>


                <!-- START DATE -->

                <div class="form-group">

                    <label>Start Date</label>

                    <input type="date"
                           name="start_date"
                           value="<%= rs.getDate("start_date") %>"
                           required>

                </div>


                <!-- END DATE -->

                <div class="form-group">

                    <label>End Date</label>

                    <input type="date"
                           name="end_date"
                           value="<%= rs.getDate("end_date") == null
                               ? ""
                               : rs.getDate("end_date") %>">

                </div>


                <!-- STATUS -->

                <div class="form-group">

                    <label>Status</label>

                    <select name="status" required>

                        <option value="ACTIVE"
                            <%= "ACTIVE".equals(rs.getString("status"))
                                ? "selected"
                                : "" %>>
                            Active
                        </option>

                        <option value="PAUSED"
                            <%= "PAUSED".equals(rs.getString("status"))
                                ? "selected"
                                : "" %>>
                            Paused
                        </option>

                        <option value="COMPLETED"
                            <%= "COMPLETED".equals(rs.getString("status"))
                                ? "selected"
                                : "" %>>
                            Completed
                        </option>

                        <option value="CANCELLED"
                            <%= "CANCELLED".equals(rs.getString("status"))
                                ? "selected"
                                : "" %>>
                            Cancelled
                        </option>

                    </select>

                </div>


                <!-- REMARKS -->

                <div class="form-group full-width">

                    <label>Remarks</label>

                    <textarea name="remarks"><%= rs.getString("remarks") == null
                        ? ""
                        : rs.getString("remarks") %></textarea>

                </div>

            </div>


            <button type="submit" class="btn">
                Update Subscription
            </button>

            <a href="subscription.jsp" class="back-btn">
                Back
            </a>

        </form>

        <%

                    } else {

        %>

                    <div class="error">
                        Subscription record not found.
                    </div>

                    <a href="subscription.jsp" class="back-btn">
                        Back to Subscriptions
                    </a>

        <%

                    }

                } catch (Exception e) {

                    e.printStackTrace();

        %>

                    <div class="error">

                        Error loading subscription:

                        <br><br>

                        <%= e.getMessage() %>

                    </div>

                    <a href="subscription.jsp" class="back-btn">
                        Back to Subscriptions
                    </a>

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

    </div>

</div>

</body>
</html>