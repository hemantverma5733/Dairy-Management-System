package com.smartdairy.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.smartdairy.util.DBConnection;

public class InvoiceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String orderIdText = request.getParameter("order_id");
        String invoiceDate = request.getParameter("invoice_date");
        String remarks = request.getParameter("remarks");

        Connection con = null;

        try {

            int orderId = Integer.parseInt(orderIdText);

            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            /*
             * Get order and customer details
             */
            String orderSql =
                    "SELECT o.customer_id, o.total_amount "
                    + "FROM orders o "
                    + "WHERE o.id = ?";

            PreparedStatement orderPs =
                    con.prepareStatement(orderSql);

            orderPs.setInt(1, orderId);

            ResultSet orderRs =
                    orderPs.executeQuery();

            if (!orderRs.next()) {

                orderRs.close();
                orderPs.close();
                con.rollback();

                response.sendRedirect(
                        "invoice.jsp?error=order");

                return;
            }

            int customerId =
                    orderRs.getInt("customer_id");

            double totalAmount =
                    orderRs.getDouble("total_amount");

            orderRs.close();
            orderPs.close();


            /*
             * Check whether invoice already exists
             */
            String checkSql =
                    "SELECT id FROM invoices WHERE order_id = ?";

            PreparedStatement checkPs =
                    con.prepareStatement(checkSql);

            checkPs.setInt(1, orderId);

            ResultSet checkRs =
                    checkPs.executeQuery();

            if (checkRs.next()) {

                checkRs.close();
                checkPs.close();
                con.rollback();

                response.sendRedirect(
                        "invoice.jsp?error=exists");

                return;
            }

            checkRs.close();
            checkPs.close();


            /*
             * Calculate already received payment
             */
            String paymentSql =
                    "SELECT COALESCE(SUM(amount), 0) "
                    + "FROM payments "
                    + "WHERE order_id = ? "
                    + "AND payment_status = 'RECEIVED'";

            PreparedStatement paymentPs =
                    con.prepareStatement(paymentSql);

            paymentPs.setInt(1, orderId);

            ResultSet paymentRs =
                    paymentPs.executeQuery();

            double paidAmount = 0;

            if (paymentRs.next()) {
                paidAmount = paymentRs.getDouble(1);
            }

            paymentRs.close();
            paymentPs.close();


            /*
             * Calculate pending amount
             */
            double pendingAmount =
                    totalAmount - paidAmount;

            if (pendingAmount < 0) {
                pendingAmount = 0;
            }


            /*
             * Determine payment status
             */
            String paymentStatus;

            if (paidAmount <= 0) {

                paymentStatus = "PENDING";

            } else if (paidAmount < totalAmount) {

                paymentStatus = "PARTIAL";

            } else {

                paymentStatus = "PAID";
            }


            /*
             * Generate invoice number
             */
            String invoiceNumber =
                    "INV-" + System.currentTimeMillis();


            /*
             * Insert invoice
             */
            String invoiceSql =
                    "INSERT INTO invoices "
                    + "(invoice_number, order_id, customer_id, "
                    + "invoice_date, total_amount, paid_amount, "
                    + "pending_amount, payment_status, remarks) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement invoicePs =
                    con.prepareStatement(invoiceSql);

            invoicePs.setString(1, invoiceNumber);
            invoicePs.setInt(2, orderId);
            invoicePs.setInt(3, customerId);

            if (invoiceDate == null ||
                    invoiceDate.trim().isEmpty()) {

                invoicePs.setObject(
                        4,
                        LocalDate.now());

            } else {

                invoicePs.setString(
                        4,
                        invoiceDate);
            }

            invoicePs.setDouble(5, totalAmount);
            invoicePs.setDouble(6, paidAmount);
            invoicePs.setDouble(7, pendingAmount);
            invoicePs.setString(8, paymentStatus);
            invoicePs.setString(9, remarks);

            invoicePs.executeUpdate();

            invoicePs.close();


            /*
             * Commit transaction
             */
            con.commit();

            response.sendRedirect(
                    "invoice.jsp?success=true");

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
                    "invoice.jsp?error=true");

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