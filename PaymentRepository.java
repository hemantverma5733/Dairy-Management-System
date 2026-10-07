package com.smartdairy.repository;

import com.smartdairy.model.Payment;
import java.sql.*;

public class PaymentRepository {
    public double getOrderTotal(Connection con, int orderId, int customerId) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement("SELECT total_amount FROM orders WHERE id = ? AND customer_id = ?")) {
            ps.setInt(1, orderId); ps.setInt(2, customerId); try (ResultSet rs = ps.executeQuery()) { if (!rs.next()) return -1; return rs.getDouble(1); }
        }
    }
    public double getReceived(Connection con, int orderId) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement("SELECT COALESCE(SUM(amount),0) FROM payments WHERE order_id = ? AND payment_status = 'RECEIVED'")) {
            ps.setInt(1, orderId); try (ResultSet rs = ps.executeQuery()) { rs.next(); return rs.getDouble(1); }
        }
    }
    public void create(Connection con, Payment p) throws SQLException {
        String sql = "INSERT INTO payments (customer_id, order_id, payment_date, amount, payment_method, payment_status, transaction_reference, remarks) VALUES (?, ?, ?, ?, ?, 'RECEIVED', ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, p.getCustomerId()); if (p.getOrderId() == null) ps.setNull(2, Types.INTEGER); else ps.setInt(2, p.getOrderId());
            ps.setDate(3, Date.valueOf(p.getPaymentDate())); ps.setDouble(4, p.getAmount()); ps.setString(5, p.getPaymentMethod());
            ps.setString(6, p.getTransactionReference()); ps.setString(7, p.getRemarks()); ps.executeUpdate();
        }
    }
    public void updateOrderStatus(Connection con, int orderId, String status) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement("UPDATE orders SET payment_status = ? WHERE id = ?")) {
            ps.setString(1, status); ps.setInt(2, orderId); ps.executeUpdate();
        }
    }
}
