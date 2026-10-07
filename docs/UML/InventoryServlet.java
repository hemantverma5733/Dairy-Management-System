package com.smartdairy.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.smartdairy.util.DBConnection;

public class InventoryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String productIdText = request.getParameter("product_id");
        String transactionType = request.getParameter("transaction_type");
        String quantityText = request.getParameter("quantity");
        String referenceType = request.getParameter("reference_type");
        String referenceIdText = request.getParameter("reference_id");
        String transactionDate = request.getParameter("transaction_date");
        String remarks = request.getParameter("remarks");

        try {

            int productId = Integer.parseInt(productIdText);
            double quantity = Double.parseDouble(quantityText);

            int referenceId = 0;

            if (referenceIdText != null
                    && !referenceIdText.trim().isEmpty()) {
                referenceId = Integer.parseInt(referenceIdText);
            }

            Connection con = DBConnection.getConnection();

            // Check current product stock
            String stockSql =
                    "SELECT stock FROM products WHERE id = ?";

            PreparedStatement stockPs =
                    con.prepareStatement(stockSql);

            stockPs.setInt(1, productId);

            var rs = stockPs.executeQuery();

            double currentStock = 0;

            if (rs.next()) {
                currentStock = rs.getDouble("stock");
            }

            rs.close();
            stockPs.close();

            // Prevent negative stock
            if ("STOCK OUT".equals(transactionType)
                    && quantity > currentStock) {

                con.close();

                response.sendRedirect(
                        "inventory.jsp?error=insufficient");

                return;
            }

            // Save inventory transaction
            String sql =
                    "INSERT INTO inventory "
                    + "(product_id, transaction_type, quantity, "
                    + "reference_type, reference_id, "
                    + "transaction_date, remarks) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(1, productId);
            ps.setString(2, transactionType);
            ps.setDouble(3, quantity);
            ps.setString(4, referenceType);

            if (referenceId == 0) {
                ps.setNull(5, java.sql.Types.INTEGER);
            } else {
                ps.setInt(5, referenceId);
            }

            ps.setString(6, transactionDate);
            ps.setString(7, remarks);

            ps.executeUpdate();

            ps.close();

            // Update product stock
            double newStock;

            if ("STOCK IN".equals(transactionType)) {

                newStock = currentStock + quantity;

            } else {

                newStock = currentStock - quantity;
            }

            String updateSql =
                    "UPDATE products SET stock = ? WHERE id = ?";

            PreparedStatement updatePs =
                    con.prepareStatement(updateSql);

            updatePs.setDouble(1, newStock);
            updatePs.setInt(2, productId);

            updatePs.executeUpdate();

            updatePs.close();
            con.close();

            response.sendRedirect(
                    "inventory.jsp?success=true");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "inventory.jsp?error=true");
        }
    }
}