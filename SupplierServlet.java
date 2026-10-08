package com.smartdairy.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.smartdairy.util.DBConnection;

public class SupplierServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String mobile = request.getParameter("mobile");
        String address = request.getParameter("address");
        String animalType = request.getParameter("animal_type");
        String bankDetails = request.getParameter("bank_details");
        String status = request.getParameter("status");

        String sql = "INSERT INTO suppliers "
                + "(name, mobile, address, animal_type, bank_details, status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, mobile);
            ps.setString(3, address);
            ps.setString(4, animalType);
            ps.setString(5, bankDetails);
            ps.setString(6, status);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("supplier.jsp?success=true");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("supplier.jsp?error=true");
        }
    }
}