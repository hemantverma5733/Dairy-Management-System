
package com.smartdairy.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.smartdairy.util.DBConnection;

public class CustomerDeleteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        try {

            Connection con = DBConnection.getConnection();

            String sql = "DELETE FROM customers WHERE id = ?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, Integer.parseInt(id));

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("customer.jsp?deleted=true");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("customer.jsp?error=true");
        }
    }
}