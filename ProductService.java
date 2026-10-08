package com.smartdairy.service;

import com.smartdairy.entity.Product;
import com.smartdairy.repository.ProductRepository;
import java.sql.SQLException;
import java.util.List;

public class ProductService {
    private final ProductRepository repository = new ProductRepository();

    public void validate(Product p) {
        if (p.getProductName() == null || p.getProductName().trim().isEmpty()) throw new IllegalArgumentException("Product name is required.");
        if (p.getSellingPrice() < 0 || p.getPurchasePrice() < 0) throw new IllegalArgumentException("Prices cannot be negative.");
        if (p.getStock() < 0 || p.getMinimumStock() < 0) throw new IllegalArgumentException("Stock values cannot be negative.");
    }
    public int create(Product p) throws Exception { validate(p); return repository.save(p); }
    public void update(Product p) throws Exception { validate(p); repository.update(p); }
    public void delete(int id) throws Exception { repository.delete(id); }
    public Product findById(int id) throws Exception { return repository.findById(id); }
    public List<Product> findAll() throws Exception { return repository.findAll(); }
}
