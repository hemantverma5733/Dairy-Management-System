package com.smartdairy.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.smartdairy.util.DBConnection;

public class DeliveryUpdateServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");
        String orderId = request.getParameter("order_id");
        String deliveryPerson = request.getParameter("delivery_person");
        String mobile = request.getParameter("mobile");
        String vehicleNumber = request.getParameter("vehicle_number");
        String deliveryDate = request.getParameter("delivery_date");
        String route = request.getParameter("route");
        String status = request.getParameter("status");
        String remarks = request.getParameter("remarks");

        String sql = "UPDATE deliveries SET "
                + "order_id = ?, "
                + "delivery_person = ?, "
                + "mobile = ?, "
                + "vehicle_number = ?, "
                + "delivery_date = ?, "
                + "route = ?, "
                + "status = ?, "
                + "remarks = ? "
                + "WHERE id = ?";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, Integer.parseInt(orderId));
            ps.setString(2, deliveryPerson);
            ps.setString(3, mobile);
            ps.setString(4, vehicleNumber);
            ps.setString(5, deliveryDate);
            ps.setString(6, route);
            ps.setString(7, status);
            ps.setString(8, remarks);
            ps.setInt(9, Integer.parseInt(id));

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("delivery.jsp?updated=true");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("delivery.jsp?error=true");
        }
    }
}