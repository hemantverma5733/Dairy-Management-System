package com.smartdairy.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.smartdairy.util.DBConnection;

public class OrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String customerIdText = request.getParameter("customer_id");
        String productIdText = request.getParameter("product_id");
        String quantityText = request.getParameter("quantity");
        String orderDate = request.getParameter("order_date");
        String status = request.getParameter("status");
        String paymentStatus = request.getParameter("payment_status");
        String remarks = request.getParameter("remarks");

        Connection con = null;

        try {

            int customerId = Integer.parseInt(customerIdText);
            int productId = Integer.parseInt(productIdText);
            double quantity = Double.parseDouble(quantityText);

            con = DBConnection.getConnection();

            con.setAutoCommit(false);

            // Get product price and current stock
            String productSql =
                    "SELECT selling_price, stock "
                    + "FROM products "
                    + "WHERE id = ?";

            PreparedStatement productPs =
                    con.prepareStatement(productSql);

            productPs.setInt(1, productId);

            ResultSet productRs =
                    productPs.executeQuery();

            double price = 0;
            double currentStock = 0;

            if (productRs.next()) {

                price = productRs.getDouble("selling_price");
                currentStock = productRs.getDouble("stock");

            } else {

                productRs.close();
                productPs.close();
                con.rollback();
                response.sendRedirect("order.jsp?error=product");
                return;
            }

            productRs.close();
            productPs.close();

            // Check stock
            if (quantity <= 0 || quantity > currentStock) {

                con.rollback();

                response.sendRedirect(
                        "order.jsp?error=stock");

                return;
            }

            // Calculate total
            double totalAmount = quantity * price;

            // Insert order
            String orderSql =
                    "INSERT INTO orders "
                    + "(customer_id, order_date, total_amount, "
                    + "status, payment_status, remarks) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";

            PreparedStatement orderPs =
                    con.prepareStatement(
                            orderSql,
                            java.sql.Statement.RETURN_GENERATED_KEYS);

            orderPs.setInt(1, customerId);
            orderPs.setString(2, orderDate);
            orderPs.setDouble(3, totalAmount);
            orderPs.setString(4, status);
            orderPs.setString(5, paymentStatus);
            orderPs.setString(6, remarks);

            orderPs.executeUpdate();

            ResultSet generatedKeys =
                    orderPs.getGeneratedKeys();

            int orderId = 0;

            if (generatedKeys.next()) {
                orderId = generatedKeys.getInt(1);
            }

            generatedKeys.close();
            orderPs.close();

            // Insert order item
            String itemSql =
                    "INSERT INTO order_items "
                    + "(order_id, product_id, quantity, price, total) "
                    + "VALUES (?, ?, ?, ?, ?)";

            PreparedStatement itemPs =
                    con.prepareStatement(itemSql);

            itemPs.setInt(1, orderId);
            itemPs.setInt(2, productId);
            itemPs.setDouble(3, quantity);
            itemPs.setDouble(4, price);
            itemPs.setDouble(5, totalAmount);

            itemPs.executeUpdate();

            itemPs.close();

            // Reduce product stock
            double newStock =
                    currentStock - quantity;

            String updateStockSql =
                    "UPDATE products "
                    + "SET stock = ? "
                    + "WHERE id = ?";

            PreparedStatement updatePs =
                    con.prepareStatement(updateStockSql);

            updatePs.setDouble(1, newStock);
            updatePs.setInt(2, productId);

            updatePs.executeUpdate();

            updatePs.close();

            // Add stock-out transaction to inventory
            String inventorySql =
                    "INSERT INTO inventory "
                    + "(product_id, transaction_type, quantity, "
                    + "reference_type, reference_id, "
                    + "transaction_date, remarks) "
                    + "VALUES (?, 'STOCK OUT', ?, 'SALE', ?, ?, ?)";

            PreparedStatement inventoryPs =
                    con.prepareStatement(inventorySql);

            inventoryPs.setInt(1, productId);
            inventoryPs.setDouble(2, quantity);
            inventoryPs.setInt(3, orderId);
            inventoryPs.setString(4, orderDate);
            inventoryPs.setString(
                    5,
                    "Stock out for Order #" + orderId
            );

            inventoryPs.executeUpdate();

            inventoryPs.close();

            con.commit();

            response.sendRedirect(
                    "order.jsp?success=true");

        } catch (Exception e) {

            e.printStackTrace();

            try {

                if (con != null) {
                    con.rollback();
                }

            } catch (Exception rollbackError) {
                rollbackError.printStackTrace();
            }

            response.sendRedirect(
                    "order.jsp?error=true");

        } finally {

            try {

                if (con != null) {
                    con.close();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}