package com.smartdairy.repository;

import com.smartdairy.entity.InventoryTransaction;
import com.smartdairy.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryRepository {
    public void save(InventoryTransaction t) throws Exception {
        String sql = "INSERT INTO inventory (product_id, transaction_type, quantity, reference_type, reference_id, transaction_date, remarks) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, t.getProductId()); ps.setString(2, t.getTransactionType()); ps.setDouble(3, t.getQuantity());
            ps.setString(4, t.getReferenceType());
            if (t.getReferenceId() == null) ps.setNull(5, Types.INTEGER); else ps.setInt(5, t.getReferenceId());
            if (t.getTransactionDate() == null) ps.setTimestamp(6, new Timestamp(System.currentTimeMillis())); else ps.setTimestamp(6, t.getTransactionDate());
            ps.setString(7, t.getRemarks());
            ps.executeUpdate();
        }
    }

    public List<InventoryTransaction> findAll() throws Exception {
        List<InventoryTransaction> list = new ArrayList<>();
        String sql = "SELECT i.*, p.product_name FROM inventory i JOIN products p ON i.product_id=p.id ORDER BY i.id DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                InventoryTransaction t = new InventoryTransaction();
                t.setId(rs.getInt("id")); t.setProductId(rs.getInt("product_id")); t.setProductName(rs.getString("product_name"));
                t.setTransactionType(rs.getString("transaction_type")); t.setQuantity(rs.getDouble("quantity"));
                t.setReferenceType(rs.getString("reference_type"));
                int ref = rs.getInt("reference_id"); t.setReferenceId(rs.wasNull() ? null : ref);
                t.setTransactionDate(rs.getTimestamp("transaction_date")); t.setRemarks(rs.getString("remarks"));
                list.add(t);
            }
        }
        return list;
    }
}
