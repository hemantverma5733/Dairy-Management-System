package com.smartdairy.repository;

import com.smartdairy.entity.Product;
import com.smartdairy.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductRepository {
    public int save(Product p) throws Exception {
        String sql = "INSERT INTO products (product_name, category, unit, purchase_price, selling_price, stock, minimum_stock, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            setProduct(ps, p);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) return rs.getInt(1); }
        }
        return 0;
    }

    public void update(Product p) throws Exception {
        String sql = "UPDATE products SET product_name=?, category=?, unit=?, purchase_price=?, selling_price=?, stock=?, minimum_stock=?, status=? WHERE id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            setProduct(ps, p);
            ps.setInt(9, p.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws Exception {
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement("DELETE FROM products WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public Product findById(int id) throws Exception {
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement("SELECT * FROM products WHERE id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? map(rs) : null; }
        }
    }

    public List<Product> findAll() throws Exception {
        List<Product> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement("SELECT * FROM products ORDER BY id DESC"); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    private void setProduct(PreparedStatement ps, Product p) throws Exception {
        ps.setString(1, p.getProductName()); ps.setString(2, p.getCategory()); ps.setString(3, p.getUnit());
        ps.setDouble(4, p.getPurchasePrice()); ps.setDouble(5, p.getSellingPrice()); ps.setDouble(6, p.getStock());
        ps.setDouble(7, p.getMinimumStock()); ps.setString(8, p.getStatus());
    }

    private Product map(ResultSet rs) throws Exception {
        return new Product(rs.getInt("id"), rs.getString("product_name"), rs.getString("category"), rs.getString("unit"),
                rs.getDouble("purchase_price"), rs.getDouble("selling_price"), rs.getDouble("stock"),
                rs.getDouble("minimum_stock"), rs.getString("status"));
    }
}
