package com.smartdairy.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.smartdairy.util.DBConnection;

public class ProductUpdateServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");
        String productName = request.getParameter("product_name");
        String category = request.getParameter("category");
        String unit = request.getParameter("unit");

        String purchasePriceText =
                request.getParameter("purchase_price");

        String sellingPriceText =
                request.getParameter("selling_price");

        String stockText =
                request.getParameter("stock");

        String minimumStockText =
                request.getParameter("minimum_stock");

        String status =
                request.getParameter("status");

        try {

            double purchasePrice = 0.0;
            double sellingPrice = Double.parseDouble(sellingPriceText);
            double stock = 0.0;
            double minimumStock = 0.0;

            if (purchasePriceText != null &&
                    !purchasePriceText.trim().isEmpty()) {

                purchasePrice =
                        Double.parseDouble(purchasePriceText);
            }

            if (stockText != null &&
                    !stockText.trim().isEmpty()) {

                stock =
                        Double.parseDouble(stockText);
            }

            if (minimumStockText != null &&
                    !minimumStockText.trim().isEmpty()) {

                minimumStock =
                        Double.parseDouble(minimumStockText);
            }

            String sql = "UPDATE products SET "
                    + "product_name = ?, "
                    + "category = ?, "
                    + "unit = ?, "
                    + "purchase_price = ?, "
                    + "selling_price = ?, "
                    + "stock = ?, "
                    + "minimum_stock = ?, "
                    + "status = ? "
                    + "WHERE id = ?";

            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, productName);
            ps.setString(2, category);
            ps.setString(3, unit);
            ps.setDouble(4, purchasePrice);
            ps.setDouble(5, sellingPrice);
            ps.setDouble(6, stock);
            ps.setDouble(7, minimumStock);
            ps.setString(8, status);
            ps.setInt(9, Integer.parseInt(id));

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect(
                    "product.jsp?updated=true");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "product.jsp?error=true");
        }
    }
}