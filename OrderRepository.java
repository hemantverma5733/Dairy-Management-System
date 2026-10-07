package com.smartdairy.repository;

import com.smartdairy.model.Order;
import com.smartdairy.model.OrderItem;
import java.sql.*;

public class OrderRepository {
    public int create(Connection con, Order order, OrderItem item) throws SQLException {
        String sql = "INSERT INTO orders (customer_id, order_date, total_amount, status, payment_status, remarks) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, order.getCustomerId()); ps.setDate(2, Date.valueOf(order.getOrderDate()));
            ps.setDouble(3, order.getTotalAmount()); ps.setString(4, order.getStatus());
            ps.setString(5, order.getPaymentStatus()); ps.setString(6, order.getRemarks()); ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (!rs.next()) throw new SQLException("Order ID was not generated"); order.setId(rs.getInt(1)); }
        }
        try (PreparedStatement ps = con.prepareStatement("INSERT INTO order_items (order_id, product_id, quantity, price, total) VALUES (?, ?, ?, ?, ?)") ) {
            ps.setInt(1, order.getId()); ps.setInt(2, item.getProductId()); ps.setDouble(3, item.getQuantity());
            ps.setDouble(4, item.getPrice()); ps.setDouble(5, item.getTotal()); ps.executeUpdate();
        }
        return order.getId();
    }
    public double[] findProduct(Connection con, int productId) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement("SELECT selling_price, stock FROM products WHERE id = ? AND status = 'ACTIVE'")) {
            ps.setInt(1, productId); try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null; return new double[]{rs.getDouble("selling_price"), rs.getDouble("stock")};
            }
        }
    }
    public void updateStock(Connection con, int productId, double stock) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement("UPDATE products SET stock = ? WHERE id = ?")) {
            ps.setDouble(1, stock); ps.setInt(2, productId); ps.executeUpdate();
        }
    }
    public void recordStockOut(Connection con, int productId, double quantity, int orderId, java.time.LocalDate date) throws SQLException {
        String sql = "INSERT INTO inventory (product_id, transaction_type, quantity, reference_type, reference_id, transaction_date, remarks) VALUES (?, 'STOCK OUT', ?, 'SALE', ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId); ps.setDouble(2, quantity); ps.setInt(3, orderId); ps.setDate(4, Date.valueOf(date)); ps.setString(5, "Stock out for Order #" + orderId); ps.executeUpdate();
        }
    }
}
