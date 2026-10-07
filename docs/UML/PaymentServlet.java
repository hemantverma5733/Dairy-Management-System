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

public class PaymentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String customerIdText = request.getParameter("customer_id");
        String orderIdText = request.getParameter("order_id");
        String paymentDate = request.getParameter("payment_date");
        String amountText = request.getParameter("amount");
        String paymentMethod = request.getParameter("payment_method");
        String transactionReference =
                request.getParameter("transaction_reference");
        String remarks = request.getParameter("remarks");

        Connection con = null;

        try {

            int customerId =
                    Integer.parseInt(customerIdText);

            int orderId = 0;

            if (orderIdText != null
                    && !orderIdText.trim().isEmpty()) {

                orderId = Integer.parseInt(orderIdText);
            }

            double amount =
                    Double.parseDouble(amountText);

            if (amount <= 0) {

                response.sendRedirect(
                        "payment.jsp?error=amount");

                return;
            }

            con = DBConnection.getConnection();

            con.setAutoCommit(false);

            double orderTotal = 0;
            double alreadyPaid = 0;

            // Check order and total amount
            if (orderId > 0) {

                String orderSql =
                        "SELECT total_amount "
                        + "FROM orders "
                        + "WHERE id = ? "
                        + "AND customer_id = ?";

                PreparedStatement orderPs =
                        con.prepareStatement(orderSql);

                orderPs.setInt(1, orderId);
                orderPs.setInt(2, customerId);

                ResultSet orderRs =
                        orderPs.executeQuery();

                if (!orderRs.next()) {

                    orderRs.close();
                    orderPs.close();
                    con.rollback();

                    response.sendRedirect(
                            "payment.jsp?error=order");

                    return;
                }

                orderTotal =
                        orderRs.getDouble("total_amount");

                orderRs.close();
                orderPs.close();


                // Calculate already paid amount
                String paidSql =
                        "SELECT COALESCE(SUM(amount), 0) "
                        + "FROM payments "
                        + "WHERE order_id = ? "
                        + "AND payment_status = 'RECEIVED'";

                PreparedStatement paidPs =
                        con.prepareStatement(paidSql);

                paidPs.setInt(1, orderId);

                ResultSet paidRs =
                        paidPs.executeQuery();

                if (paidRs.next()) {

                    alreadyPaid =
                            paidRs.getDouble(1);
                }

                paidRs.close();
                paidPs.close();


                double pending =
                        orderTotal - alreadyPaid;

                if (amount > pending) {

                    con.rollback();

                    response.sendRedirect(
                            "payment.jsp?error=excess");

                    return;
                }
            }


            // Save payment
            String paymentSql =
                    "INSERT INTO payments "
                    + "(customer_id, order_id, payment_date, "
                    + "amount, payment_method, payment_status, "
                    + "transaction_reference, remarks) "
                    + "VALUES (?, ?, ?, ?, ?, 'RECEIVED', ?, ?)";

            PreparedStatement paymentPs =
                    con.prepareStatement(paymentSql);

            paymentPs.setInt(1, customerId);

            if (orderId == 0) {
                paymentPs.setNull(
                        2,
                        java.sql.Types.INTEGER
                );
            } else {
                paymentPs.setInt(2, orderId);
            }

            paymentPs.setString(3, paymentDate);
            paymentPs.setDouble(4, amount);
            paymentPs.setString(5, paymentMethod);
            paymentPs.setString(6, transactionReference);
            paymentPs.setString(7, remarks);

            paymentPs.executeUpdate();

            paymentPs.close();


            // Update order payment status
            if (orderId > 0) {

                double totalPaid =
                        alreadyPaid + amount;

                String newPaymentStatus;

                if (totalPaid >= orderTotal) {

                    newPaymentStatus = "PAID";

                } else {

                    newPaymentStatus = "PARTIAL";
                }

                String updateSql =
                        "UPDATE orders "
                        + "SET payment_status = ? "
                        + "WHERE id = ?";

                PreparedStatement updatePs =
                        con.prepareStatement(updateSql);

                updatePs.setString(
                        1,
                        newPaymentStatus
                );

                updatePs.setInt(2, orderId);

                updatePs.executeUpdate();

                updatePs.close();
            }


            con.commit();

            response.sendRedirect(
                    "payment.jsp?success=true");

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
                    "payment.jsp?error=true");

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