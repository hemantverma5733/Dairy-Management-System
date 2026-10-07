package com.smartdairy.service;

import com.smartdairy.model.Payment;
import com.smartdairy.repository.PaymentRepository;
import com.smartdairy.util.DBConnection;
import java.sql.Connection;
import java.time.LocalDate;

public class PaymentService {
    private final PaymentRepository repository = new PaymentRepository();
    public void receive(int customerId,Integer orderId,LocalDate date,double amount,String method,String reference,String remarks) throws Exception {
        if(customerId<=0 || amount<=0) throw new IllegalArgumentException("Invalid payment details");
        try(Connection con=DBConnection.getConnection()){
            con.setAutoCommit(false);
            try{
                double alreadyPaid=0;
                if(orderId!=null){
                    double total=repository.getOrderTotal(con,orderId,customerId);
                    if(total<0) throw new IllegalArgumentException("Order does not belong to customer");
                    alreadyPaid=repository.getReceived(con,orderId);
                    if(amount>total-alreadyPaid+0.000001) throw new IllegalArgumentException("Payment exceeds pending amount");
                }
                Payment p=new Payment(); p.setCustomerId(customerId); p.setOrderId(orderId); p.setPaymentDate(date); p.setAmount(amount); p.setPaymentMethod(method); p.setPaymentStatus("RECEIVED"); p.setTransactionReference(reference); p.setRemarks(remarks);
                repository.create(con,p);
                if(orderId!=null){ double total=repository.getOrderTotal(con,orderId,customerId); String status=(alreadyPaid+amount>=total-0.000001)?"PAID":"PARTIAL"; repository.updateOrderStatus(con,orderId,status); }
                con.commit();
            }catch(Exception e){con.rollback();throw e;}
        }
    }
}
