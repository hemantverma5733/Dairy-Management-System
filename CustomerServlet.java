
package com.smartdairy.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.smartdairy.util.DBConnection;

public class CustomerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String mobile = request.getParameter("mobile");
        String address = request.getParameter("address");
        String customerType = request.getParameter("customer_type");
        String status = request.getParameter("status");

        String sql = "INSERT INTO customers "
                + "(name, mobile, address, customer_type, status) "
                + "VALUES (?, ?, ?, ?, ?)";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, mobile);
            ps.setString(3, address);
            ps.setString(4, customerType);
            ps.setString(5, status);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("customer.jsp?success=true");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("customer.jsp?error=true");
        }
    }
}