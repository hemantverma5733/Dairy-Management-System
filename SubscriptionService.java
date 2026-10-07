package com.smartdairy.service;

import com.smartdairy.model.Subscription;
import com.smartdairy.repository.SubscriptionRepository;
import com.smartdairy.util.DBConnection;
import java.time.LocalDate;

public class SubscriptionService {
    private final SubscriptionRepository repository = new SubscriptionRepository();
    public void create(int customerId,int productId,double quantity,String shift,LocalDate start,LocalDate end,String status,String remarks) throws Exception { try(var con=DBConnection.getConnection()){ repository.create(con, build(customerId,productId,quantity,shift,start,end,status,remarks)); } }
    public void update(int id,int customerId,int productId,double quantity,String shift,LocalDate start,LocalDate end,String status,String remarks) throws Exception { Subscription s=build(customerId,productId,quantity,shift,start,end,status,remarks); s.setId(id); try(var con=DBConnection.getConnection()){repository.update(con,s);} }
    public void delete(int id) throws Exception { try(var con=DBConnection.getConnection()){repository.delete(con,id);} }
    private Subscription build(int c,int p,double q,String sh,LocalDate st,LocalDate en,String status,String remarks){ if(c<=0||p<=0||q<=0||st==null) throw new IllegalArgumentException("Invalid subscription details"); if(en!=null&&en.isBefore(st)) throw new IllegalArgumentException("End date cannot be before start date"); Subscription s=new Subscription(); s.setCustomerId(c);s.setProductId(p);s.setQuantity(q);s.setShift(sh);s.setStartDate(st);s.setEndDate(en);s.setStatus(status);s.setRemarks(remarks);return s; }
}
