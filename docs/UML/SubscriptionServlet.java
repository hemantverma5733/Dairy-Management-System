package com.smartdairy.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.smartdairy.util.DBConnection;

public class SubscriptionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String customerId = request.getParameter("customer_id");
        String productId = request.getParameter("product_id");
        String quantity = request.getParameter("quantity");
        String shift = request.getParameter("shift");
        String startDate = request.getParameter("start_date");
        String endDate = request.getParameter("end_date");
        String status = request.getParameter("status");
        String remarks = request.getParameter("remarks");

        String sql = "INSERT INTO subscriptions "
                + "(customer_id, product_id, quantity, shift, "
                + "start_date, end_date, status, remarks) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, Integer.parseInt(customerId));
            ps.setInt(2, Integer.parseInt(productId));
            ps.setDouble(3, Double.parseDouble(quantity));
            ps.setString(4, shift);
            ps.setString(5, startDate);

            if (endDate == null || endDate.trim().isEmpty()) {
                ps.setNull(6, java.sql.Types.DATE);
            } else {
                ps.setString(6, endDate);
            }

            ps.setString(7, status);
            ps.setString(8, remarks);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("subscription.jsp?success=true");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("subscription.jsp?error=true");
        }
    }
}