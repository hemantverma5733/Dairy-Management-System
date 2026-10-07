package com.smartdairy.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.smartdairy.util.DBConnection;

public class DistributorServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String mobile = request.getParameter("mobile");
        String shopName = request.getParameter("shop_name");
        String address = request.getParameter("address");
        String area = request.getParameter("area");
        String status = request.getParameter("status");

        String sql = "INSERT INTO distributors "
                + "(name, mobile, shop_name, address, area, status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, mobile);
            ps.setString(3, shopName);
            ps.setString(4, address);
            ps.setString(5, area);
            ps.setString(6, status);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("distributor.jsp?success=true");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("distributor.jsp?error=true");
        }
    }
}