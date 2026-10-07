package com.smartdairy.service;

import com.smartdairy.model.Order;
import com.smartdairy.model.OrderItem;
import com.smartdairy.repository.OrderRepository;
import com.smartdairy.util.DBConnection;
import java.sql.Connection;
import java.time.LocalDate;

public class OrderService {
    private final OrderRepository repository = new OrderRepository();
    public int placeOrder(int customerId, int productId, double quantity, LocalDate date, String status, String paymentStatus, String remarks) throws Exception {
        if(customerId<=0 || productId<=0 || quantity<=0) throw new IllegalArgumentException("Invalid order details");
        try(Connection con=DBConnection.getConnection()){
            con.setAutoCommit(false);
            try{
                double[] product=repository.findProduct(con,productId);
                if(product==null) throw new IllegalArgumentException("Product not available");
                if(quantity>product[1]) throw new IllegalArgumentException("Insufficient stock");
                OrderItem item=new OrderItem(productId,quantity,product[0]);
                Order order=new Order(customerId,date,item.getTotal(),status,paymentStatus,remarks);
                int id=repository.create(con,order,item);
                repository.updateStock(con,productId,product[1]-quantity);
                repository.recordStockOut(con,productId,quantity,id,date);
                con.commit(); return id;
            }catch(Exception e){con.rollback();throw e;}
        }
    }
}
