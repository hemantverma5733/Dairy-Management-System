package com.smartdairy.repository;

import com.smartdairy.entity.Customer;
import com.smartdairy.util.DBConnection;
import java.sql.*;
import java.util.*;

public class CustomerRepository {
    private Customer map(ResultSet rs) throws SQLException {
        return new Customer(rs.getInt("id"), rs.getString("name"), rs.getString("mobile"),
                rs.getString("address"), rs.getString("customer_type"), rs.getString("status"));
    }
    public int save(Customer c) throws Exception {
        String sql="INSERT INTO customers(name,mobile,address,customer_type,status) VALUES(?,?,?,?,?)";
        try(Connection con=DBConnection.getConnection(); PreparedStatement ps=con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1,c.getName()); ps.setString(2,c.getMobile()); ps.setString(3,c.getAddress()); ps.setString(4,c.getCustomerType()); ps.setString(5,c.getStatus()); ps.executeUpdate();
            try(ResultSet rs=ps.getGeneratedKeys()){ if(rs.next()) return rs.getInt(1); }
        } return 0;
    }
    public boolean update(Customer c) throws Exception {
        String sql="UPDATE customers SET name=?,mobile=?,address=?,customer_type=?,status=? WHERE id=?";
        try(Connection con=DBConnection.getConnection(); PreparedStatement ps=con.prepareStatement(sql)) {
            ps.setString(1,c.getName()); ps.setString(2,c.getMobile()); ps.setString(3,c.getAddress()); ps.setString(4,c.getCustomerType()); ps.setString(5,c.getStatus()); ps.setInt(6,c.getId()); return ps.executeUpdate()>0;
        }
    }
    public boolean delete(int id) throws Exception {
        try(Connection con=DBConnection.getConnection(); PreparedStatement ps=con.prepareStatement("DELETE FROM customers WHERE id=?")){ps.setInt(1,id); return ps.executeUpdate()>0;}
    }
    public Customer findById(int id) throws Exception {
        try(Connection con=DBConnection.getConnection(); PreparedStatement ps=con.prepareStatement("SELECT * FROM customers WHERE id=?")){ps.setInt(1,id); try(ResultSet rs=ps.executeQuery()){return rs.next()?map(rs):null;}}
    }
    public List<Customer> search(String q) throws Exception {
        List<Customer> list=new ArrayList<>(); String sql="SELECT * FROM customers WHERE name LIKE ? OR mobile LIKE ? OR address LIKE ? OR customer_type LIKE ? ORDER BY id DESC";
        try(Connection con=DBConnection.getConnection(); PreparedStatement ps=con.prepareStatement(sql)){String s="%"+(q==null?"":q.trim())+"%"; for(int i=1;i<=4;i++) ps.setString(i,s); try(ResultSet rs=ps.executeQuery()){while(rs.next()) list.add(map(rs));}} return list;
    }
    public int countActive() throws Exception { try(Connection con=DBConnection.getConnection(); PreparedStatement ps=con.prepareStatement("SELECT COUNT(*) FROM customers WHERE status='ACTIVE'")){try(ResultSet rs=ps.executeQuery()){rs.next();return rs.getInt(1);}} }
    public int countAll() throws Exception { try(Connection con=DBConnection.getConnection(); PreparedStatement ps=con.prepareStatement("SELECT COUNT(*) FROM customers")){try(ResultSet rs=ps.executeQuery()){rs.next();return rs.getInt(1);}} }
}
