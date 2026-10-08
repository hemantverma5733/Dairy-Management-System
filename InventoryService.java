package com.smartdairy.service;

import com.smartdairy.entity.InventoryTransaction;
import com.smartdairy.entity.Product;
import com.smartdairy.repository.InventoryRepository;
import com.smartdairy.repository.ProductRepository;
import com.smartdairy.util.DBConnection;
import java.sql.*;
import java.util.List;

public class InventoryService {
    private final InventoryRepository inventoryRepository = new InventoryRepository();
    private final ProductRepository productRepository = new ProductRepository();

    public void recordTransaction(InventoryTransaction t) throws Exception {
        if (t.getQuantity() <= 0) throw new IllegalArgumentException("Quantity must be greater than zero.");
        if (!"STOCK IN".equals(t.getTransactionType()) && !"STOCK OUT".equals(t.getTransactionType())) throw new IllegalArgumentException("Invalid transaction type.");

        Connection con = DBConnection.getConnection();
        try {
            con.setAutoCommit(false);
            double current;
            try (PreparedStatement ps = con.prepareStatement("SELECT stock FROM products WHERE id=? FOR UPDATE")) {
                ps.setInt(1, t.getProductId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) throw new IllegalArgumentException("Product not found.");
                    current = rs.getDouble("stock");
                }
            }
            double newStock = "STOCK IN".equals(t.getTransactionType()) ? current + t.getQuantity() : current - t.getQuantity();
            if (newStock < 0) throw new IllegalArgumentException("Insufficient stock.");

            try (PreparedStatement ps = con.prepareStatement("INSERT INTO inventory (product_id, transaction_type, quantity, reference_type, reference_id, transaction_date, remarks) VALUES (?, ?, ?, ?, ?, ?, ?)")) {
                ps.setInt(1, t.getProductId()); ps.setString(2, t.getTransactionType()); ps.setDouble(3, t.getQuantity()); ps.setString(4, t.getReferenceType());
                if (t.getReferenceId() == null) ps.setNull(5, Types.INTEGER); else ps.setInt(5, t.getReferenceId());
                if (t.getTransactionDate() == null) ps.setTimestamp(6, new Timestamp(System.currentTimeMillis())); else ps.setTimestamp(6, t.getTransactionDate());
                ps.setString(7, t.getRemarks()); ps.executeUpdate();
            }
            try (PreparedStatement ps = con.prepareStatement("UPDATE products SET stock=? WHERE id=?")) { ps.setDouble(1, newStock); ps.setInt(2, t.getProductId()); ps.executeUpdate(); }
            con.commit();
        } catch (Exception e) {
            try { con.rollback(); } catch (SQLException ignored) {}
            if (e instanceof SQLException) throw (SQLException)e;
            throw e;
        } finally { try { con.setAutoCommit(true); } catch (SQLException ignored) {} con.close(); }
    }

    public List<InventoryTransaction> findAll() throws Exception { return inventoryRepository.findAll(); }
    public List<Product> findProducts() throws Exception { return productRepository.findAll(); }
}
