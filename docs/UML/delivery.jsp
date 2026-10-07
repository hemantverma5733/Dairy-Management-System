<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Smart Dairy - Delivery Management</title>

    <style>

        * {
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            margin: 0;
            background: #f4f6f9;
        }

        .header {
            background: #6a1b9a;
            color: white;
            padding: 20px 35px;
            font-size: 25px;
            font-weight: bold;
        }

        .container {
            width: 94%;
            margin: 30px auto;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            margin-bottom: 25px;
        }

        h2 {
            margin-top: 0;
            color: #333;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
            color: #444;
        }

        input,
        select,
        textarea {
            width: 100%;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        textarea {
            height: 50px;
            resize: vertical;
        }

        .full {
            grid-column: span 3;
        }

        .btn {
            margin-top: 20px;
            padding: 12px 25px;
            background: #6a1b9a;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
        }

        .btn:hover {
            background: #4a148c;
        }

        .message {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 6px;
            background: #e8f5e9;
            color: #2e7d32;
            font-weight: bold;
        }

        .error {
            background: #ffebee;
            color: #c62828;
        }

        .search-box {
            margin-bottom: 20px;
        }

        .search-box input {
            max-width: 400px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th {
            background: #6a1b9a;
            color: white;
            padding: 12px;
            text-align: left;
        }

        td {
            padding: 11px;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background: #f5f5f5;
        }

        .edit {
            color: #1565c0;
            text-decoration: none;
            font-weight: bold;
            margin-right: 10px;
        }

        .delete {
            color: #c62828;
            text-decoration: none;
            font-weight: bold;
        }

        .status {
            padding: 5px 10px;
            border-radius: 15px;
            background: #f3e5f5;
            color: #6a1b9a;
            font-size: 12px;
            font-weight: bold;
        }

        @media(max-width: 900px) {

            .form-grid {
                grid-template-columns: 1fr;
            }

            .full {
                grid-column: span 1;
            }

            table {
                font-size: 12px;
            }

        }

    </style>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>

<div class="header">
    Smart Dairy - Delivery Management
</div>

<div class="container">


    <!-- SUCCESS / ERROR MESSAGES -->

    <% if ("true".equals(request.getParameter("success"))) { %>

        <div class="message">
            Delivery assigned successfully.
        </div>

    <% } %>


    <% if ("true".equals(request.getParameter("updated"))) { %>

        <div class="message">
            Delivery updated successfully.
        </div>

    <% } %>


    <% if ("true".equals(request.getParameter("deleted"))) { %>

        <div class="message">
            Delivery deleted successfully.
        </div>

    <% } %>


    <% if ("true".equals(request.getParameter("error"))) { %>

        <div class="message error">
            Something went wrong. Please try again.
        </div>

    <% } %>


    <!-- ADD DELIVERY -->

    <div class="card">

        <h2>Assign Delivery</h2>

        <form action="DeliveryController" method="post">

            <div class="form-grid">


                <!-- ORDER -->

                <div>

                    <label>Order</label>

                    <select name="order_id" required>

                        <option value="">
                            Select Order
                        </option>

                        <%

                            Connection orderCon = null;
                            PreparedStatement orderPs = null;
                            ResultSet orderRs = null;

                            try {

                                orderCon =
                                    DBConnection.getConnection();

                                String orderSql =
                                    "SELECT o.id, "
                                    + "o.order_date, "
                                    + "c.name AS customer_name, "
                                    + "o.total_amount "
                                    + "FROM orders o "
                                    + "JOIN customers c "
                                    + "ON o.customer_id = c.id "
                                    + "WHERE o.status <> 'CANCELLED' "
                                    + "ORDER BY o.id DESC";

                                orderPs =
                                    orderCon.prepareStatement(orderSql);

                                orderRs =
                                    orderPs.executeQuery();

                                while (orderRs.next()) {

                        %>

                            <option value="<%= orderRs.getInt("id") %>">

                                Order #<%= orderRs.getInt("id") %>
                                -
                                <%= orderRs.getString("customer_name") %>
                                -
                                Rs.<%= orderRs.getDouble("total_amount") %>

                            </option>

                        <%

                                }

                            } catch (Exception e) {

                                out.println(
                                    "<option value=''>"
                                    + "Unable to load orders"
                                    + "</option>"
                                );

                            } finally {

                                try {
                                    if (orderRs != null)
                                        orderRs.close();
                                } catch (Exception e) {}

                                try {
                                    if (orderPs != null)
                                        orderPs.close();
                                } catch (Exception e) {}

                                try {
                                    if (orderCon != null)
                                        orderCon.close();
                                } catch (Exception e) {}

                            }

                        %>

                    </select>

                </div>


                <!-- DELIVERY PERSON -->

                <div>

                    <label>Delivery Person</label>

                    <input type="text"
                           name="delivery_person"
                           placeholder="Enter delivery person"
                           required>

                </div>


                <!-- MOBILE -->

                <div>

                    <label>Mobile Number</label>

                    <input type="text"
                           name="mobile"
                           placeholder="Enter mobile number"
                           maxlength="15">

                </div>


                <!-- VEHICLE -->

                <div>

                    <label>Vehicle Number</label>

                    <input type="text"
                           name="vehicle_number"
                           placeholder="e.g. RJ14AB1234">

                </div>


                <!-- DATE -->

                <div>

                    <label>Delivery Date</label>

                    <input type="date"
                           name="delivery_date"
                           id="deliveryDate"
                           required>

                </div>


                <!-- ROUTE -->

                <div>

                    <label>Route / Area</label>

                    <input type="text"
                           name="route"
                           placeholder="Enter delivery route">

                </div>


                <!-- STATUS -->

                <div>

                    <label>Status</label>

                    <select name="status">

                        <option value="ASSIGNED">
                            ASSIGNED
                        </option>

                        <option value="OUT FOR DELIVERY">
                            OUT FOR DELIVERY
                        </option>

                        <option value="DELIVERED">
                            DELIVERED
                        </option>

                        <option value="FAILED">
                            FAILED
                        </option>

                        <option value="CANCELLED">
                            CANCELLED
                        </option>

                    </select>

                </div>


                <!-- REMARKS -->

                <div class="full">

                    <label>Remarks</label>

                    <textarea name="remarks"
                              placeholder="Enter delivery remarks"></textarea>

                </div>

            </div>


            <button type="submit" class="btn">
                Assign Delivery
            </button>

        </form>

    </div>


    <!-- DELIVERY HISTORY -->

    <div class="card">

        <h2>Delivery History</h2>


        <div class="search-box">

            <input type="text"
                   id="searchInput"
                   placeholder="Search delivery..."
                   onkeyup="searchTable()">

        </div>


        <table id="deliveryTable">

            <thead>

                <tr>

                    <th>ID</th>
                    <th>Order</th>
                    <th>Customer</th>
                    <th>Delivery Person</th>
                    <th>Mobile</th>
                    <th>Vehicle</th>
                    <th>Date</th>
                    <th>Route</th>
                    <th>Status</th>
                    <th>Action</th>

                </tr>

            </thead>


            <tbody>

            <%

                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {

                    con =
                        DBConnection.getConnection();

                    String sql =
                        "SELECT d.*, "
                        + "c.name AS customer_name "
                        + "FROM deliveries d "
                        + "JOIN orders o "
                        + "ON d.order_id = o.id "
                        + "JOIN customers c "
                        + "ON o.customer_id = c.id "
                        + "ORDER BY d.id DESC";

                    ps =
                        con.prepareStatement(sql);

                    rs =
                        ps.executeQuery();

                    while (rs.next()) {

            %>

                <tr>

                    <td>
                        <%= rs.getInt("id") %>
                    </td>

                    <td>
                        #<%= rs.getInt("order_id") %>
                    </td>

                    <td>
                        <%= rs.getString("customer_name") %>
                    </td>

                    <td>
                        <%= rs.getString("delivery_person") %>
                    </td>

                    <td>
                        <%= rs.getString("mobile") %>
                    </td>

                    <td>
                        <%= rs.getString("vehicle_number") %>
                    </td>

                    <td>
                        <%= rs.getDate("delivery_date") %>
                    </td>

                    <td>
                        <%= rs.getString("route") %>
                    </td>

                    <td>

                        <span class="status">
                            <%= rs.getString("status") %>
                        </span>

                    </td>

                    <td>

                        <a class="edit"
                           href="delivery_edit.jsp?id=<%= rs.getInt("id") %>">
                            Edit
                        </a>

                        <a class="delete"
                           href="DeliveryDeleteServlet?id=<%= rs.getInt("id") %>"
                           onclick="return confirm('Are you sure you want to delete this delivery?');">
                            Delete
                        </a>

                    </td>

                </tr>

            <%

                    }

                } catch (Exception e) {

                    out.println(
                        "<tr>"
                        + "<td colspan='10'>"
                        + "Error loading deliveries: "
                        + e.getMessage()
                        + "</td>"
                        + "</tr>"
                    );

                } finally {

                    try {
                        if (rs != null)
                            rs.close();
                    } catch (Exception e) {}

                    try {
                        if (ps != null)
                            ps.close();
                    } catch (Exception e) {}

                    try {
                        if (con != null)
                            con.close();
                    } catch (Exception e) {}

                }

            %>

            </tbody>

        </table>

    </div>

</div>


<script>

    // Automatically set today's date

    document.getElementById("deliveryDate").value =
        new Date().toISOString().split("T")[0];


    // Search delivery table

    function searchTable() {

        let input =
            document.getElementById("searchInput");

        let filter =
            input.value.toLowerCase();

        let table =
            document.getElementById("deliveryTable");

        let rows =
            table.getElementsByTagName("tr");


        for (let i = 1; i < rows.length; i++) {

            let text =
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