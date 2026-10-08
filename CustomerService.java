package com.smartdairy.service;

import com.smartdairy.entity.Customer;
import com.smartdairy.repository.CustomerRepository;
import java.util.List;

public class CustomerService {
    private final CustomerRepository repository=new CustomerRepository();
    public int create(Customer c) throws Exception { validate(c); return repository.save(c); }
    public boolean update(Customer c) throws Exception { if(c.getId()<=0) throw new IllegalArgumentException("Invalid customer id"); validate(c); return repository.update(c); }
    public boolean delete(int id) throws Exception { if(id<=0) throw new IllegalArgumentException("Invalid customer id"); return repository.delete(id); }
    public Customer findById(int id) throws Exception { return repository.findById(id); }
    public List<Customer> search(String q) throws Exception { return repository.search(q); }
    public int countActive() throws Exception { return repository.countActive(); }
    public int countAll() throws Exception { return repository.countAll(); }
    private void validate(Customer c){
        if(c.getName()==null || c.getName().trim().length()<2) throw new IllegalArgumentException("Customer name is required");
        if(c.getMobile()==null || !c.getMobile().matches("[0-9]{10}")) throw new IllegalArgumentException("Mobile must contain 10 digits");
        if(c.getCustomerType()==null || c.getCustomerType().trim().isEmpty()) throw new IllegalArgumentException("Customer type is required");
        if(c.getStatus()==null || !("ACTIVE".equals(c.getStatus()) || "INACTIVE".equals(c.getStatus()))) throw new IllegalArgumentException("Invalid status");
    }
}
