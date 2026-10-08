package com.smartdairy.service;
import com.smartdairy.entity.Supplier; import com.smartdairy.repository.SupplierRepository; import java.util.*;
public class SupplierService {private final SupplierRepository repo=new SupplierRepository();
 public int create(Supplier s)throws Exception{validate(s);return repo.save(s);} public boolean update(Supplier s)throws Exception{validate(s);return repo.update(s);} public boolean delete(int id)throws Exception{if(id<=0)throw new IllegalArgumentException("Invalid supplier id");return repo.delete(id);} public Supplier get(int id)throws Exception{return repo.findById(id);} public List<Supplier> search(String q)throws Exception{return repo.findAll(q);}
 private void validate(Supplier s){if(s==null||s.getName()==null||s.getName().trim().isEmpty())throw new IllegalArgumentException("Supplier name is required");if(s.getMobile()==null||!s.getMobile().matches("[0-9]{10}"))throw new IllegalArgumentException("Mobile must contain 10 digits");if(s.getStatus()==null||(!s.getStatus().equals("ACTIVE")&&!s.getStatus().equals("INACTIVE")))throw new IllegalArgumentException("Invalid status");}
}
