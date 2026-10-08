package com.smartdairy.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.smartdairy.util.DBConnection;

public class MilkCollectionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String collectionDate = request.getParameter("collection_date");
        String supplierName = request.getParameter("supplier_name");
        String shift = request.getParameter("shift");
        String animalType = request.getParameter("animal_type");

        String quantityText = request.getParameter("quantity");
        String fatText = request.getParameter("fat");
        String snfText = request.getParameter("snf");
        String rateText = request.getParameter("rate");

        try {

            double quantity = Double.parseDouble(quantityText);
            double rate = Double.parseDouble(rateText);

            double fat = 0.0;
            double snf = 0.0;

            if (fatText != null && !fatText.trim().isEmpty()) {
                fat = Double.parseDouble(fatText);
            }

            if (snfText != null && !snfText.trim().isEmpty()) {
                snf = Double.parseDouble(snfText);
            }

            double amount = quantity * rate;

            String sql = "INSERT INTO milk_collection "
                    + "(collection_date, supplier_name, shift, animal_type, "
                    + "quantity, fat, snf, rate, amount) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, collectionDate);
            ps.setString(2, supplierName);
            ps.setString(3, shift);
            ps.setString(4, animalType);
            ps.setDouble(5, quantity);
            ps.setDouble(6, fat);
            ps.setDouble(7, snf);
            ps.setDouble(8, rate);
            ps.setDouble(9, amount);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("milk_collection.jsp?success=true");

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType("text/html");

            response.getWriter().println(
                    "<h2>Error saving milk collection</h2>");

            response.getWriter().println(
                    "<p>" + e.getMessage() + "</p>");
        }
    }
}