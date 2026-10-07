
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.smartdairy.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Customer - Smart Dairy</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f8;
        }

        .header {
            background: #2c3e50;
            color: white;
            padding: 20px 30px;
            font-size: 25px;
            font-weight: bold;
        }

        .container {
            width: 70%;
            margin: 35px auto;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h2 {
            color: #2c3e50;
            margin-top: 0;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
        }

        input, select {
            width: 100%;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
        }

        .buttons {
            margin-top: 25px;
        }

        button {
            background: #27ae60;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
        }

        .back {
            background: #7f8c8d;
            color: white;
            text-decoration: none;
            padding: 12px 25px;
            border-radius: 6px;
            margin-left: 10px;
        }

        @media(max-width: 700px) {

            .container {
                width: 90%;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<div class="header">
    Smart Dairy - Edit Customer / Buyer
</div>

<div class="container">

    <div class="card">

        <h2>Edit Customer / Buyer</h2>

        <%
            String id = request.getParameter("id");

            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {

                con = DBConnection.getConnection();

                ps = con.prepareStatement(
                    "SELECT * FROM customers WHERE id = ?"
                );

                ps.setInt(
                    1,
                    Integer.parseInt(id)
                );

                rs = ps.executeQuery();

                if (rs.next()) {
        %>

        <form action="CustomerUpdateServlet" method="post">

            <input type="hidden"
                   name="id"
                   value="<%= rs.getInt("id") %>">


            <div class="form-grid">

                <div>

                    <label>Name</label>

                    <input type="text"
                           name="name"
                           value="<%= rs.getString("name") %>"
                           required>

                </div>


                <div>

                    <label>Mobile</label>

                    <input type="text"
                           name="mobile"
                           value="<%= rs.getString("mobile") %>"
                           required>

                </div>


                <div>

                    <label>Address</label>

                    <input type="text"
                           name="address"
                           value="<%= rs.getString("address") %>">

                </div>


                <div>

                    <label>Customer Type</label>

                    <select name="customer_type">

                        <option value="RETAIL"
                            <%= "RETAIL".equals(rs.getString("customer_type"))
                            ? "selected" : "" %>>
                            Retail
                        </option>

                        <option value="WHOLESALER"
                            <%= "WHOLESALER".equals(rs.getString("customer_type"))
                            ? "selected" : "" %>>
                            Wholesaler
                        </option>

                        <option value="HOTEL"
                            <%= "HOTEL".equals(rs.getString("customer_type"))
                            ? "selected" : "" %>>
                            Hotel
                        </option>

                        <option value="RESTAURANT"
                            <%= "RESTAURANT".equals(rs.getString("customer_type"))
                            ? "selected" : "" %>>
                            Restaurant
                        </option>

                        <option value="OTHER"
                            <%= "OTHER".equals(rs.getString("customer_type"))
                            ? "selected" : "" %>>
                            Other
                        </option>

                    </select>

                </div>


                <div>

                    <label>Status</label>

                    <select name="status">

                        <option value="ACTIVE"
                            <%= "ACTIVE".equals(rs.getString("status"))
                            ? "selected" : "" %>>
                            ACTIVE
                        </option>

                        <option value="INACTIVE"
                            <%= "INACTIVE".equals(rs.getString("status"))
                            ? "selected" : "" %>>
                            INACTIVE
                        </option>

                    </select>

                </div>

            </div>


            <div class="buttons">

                <button type="submit">
                    Update Customer
                </button>

                <a href="customer.jsp" class="back">
                    Back
                </a>

            </div>

        </form>

        <%
                } else {

                    out.println("<h3>Customer not found.</h3>");

                }

            } catch (Exception e) {

                out.println(
                    "<h3>Error: " +
                    e.getMessage() +
                    "</h3>"
                );

            } finally {

                try {

                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();

                } catch (Exception e) {
                }
            }
        %>

    </div>

</div>

</body>
</html>