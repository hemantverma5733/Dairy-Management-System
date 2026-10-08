package com.smartdairy.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.smartdairy.util.DBConnection;

public class ExpenseServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String expenseDate = request.getParameter("expense_date");
        String category = request.getParameter("category");
        String amountText = request.getParameter("amount");
        String description = request.getParameter("description");
        String paymentMethod = request.getParameter("payment_method");

        String sql = "INSERT INTO expenses "
                + "(expense_date, category, amount, description, payment_method) "
                + "VALUES (?, ?, ?, ?, ?)";

        try {

            double amount = Double.parseDouble(amountText);

            if (amount <= 0) {
                response.sendRedirect("expense.jsp?error=amount");
                return;
            }

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, expenseDate);
            ps.setString(2, category);
            ps.setDouble(3, amount);
            ps.setString(4, description);
            ps.setString(5, paymentMethod);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("expense.jsp?success=true");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("expense.jsp?error=true");
        }
    }
}