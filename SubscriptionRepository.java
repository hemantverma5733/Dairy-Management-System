package com.smartdairy.repository;

import com.smartdairy.model.Subscription;
import java.sql.*;

public class SubscriptionRepository {
    public void create(Connection con, Subscription s) throws SQLException {
        String sql = "INSERT INTO subscriptions (customer_id, product_id, quantity, shift, start_date, end_date, status, remarks) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) { bind(ps, s); ps.executeUpdate(); }
    }
    public void update(Connection con, Subscription s) throws SQLException {
        String sql = "UPDATE subscriptions SET customer_id=?, product_id=?, quantity=?, shift=?, start_date=?, end_date=?, status=?, remarks=? WHERE id=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) { bind(ps, s); ps.setInt(9, s.getId()); ps.executeUpdate(); }
    }
    private void bind(PreparedStatement ps, Subscription s) throws SQLException {
        ps.setInt(1,s.getCustomerId()); ps.setInt(2,s.getProductId()); ps.setDouble(3,s.getQuantity()); ps.setString(4,s.getShift());
        ps.setDate(5,Date.valueOf(s.getStartDate())); if(s.getEndDate()==null) ps.setNull(6,Types.DATE); else ps.setDate(6,Date.valueOf(s.getEndDate()));
        ps.setString(7,s.getStatus()); ps.setString(8,s.getRemarks());
    }
    public void delete(Connection con, int id) throws SQLException { try(PreparedStatement ps=con.prepareStatement("DELETE FROM subscriptions WHERE id=?")){ps.setInt(1,id);ps.executeUpdate();} }
}
