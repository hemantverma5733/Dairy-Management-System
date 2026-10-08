package com.smartdairy.entity;

public class Product {
    private int id;
    private String productName;
    private String category;
    private String unit;
    private double purchasePrice;
    private double sellingPrice;
    private double stock;
    private double minimumStock;
    private String status;

    public Product() {}

    public Product(int id, String productName, String category, String unit,
                   double purchasePrice, double sellingPrice, double stock,
                   double minimumStock, String status) {
        this.id = id;
        this.productName = productName;
        this.category = category;
        this.unit = unit;
        this.purchasePrice = purchasePrice;
        this.sellingPrice = sellingPrice;
        this.stock = stock;
        this.minimumStock = minimumStock;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public double getPurchasePrice() { return purchasePrice; }
    public void setPurchasePrice(double purchasePrice) { this.purchasePrice = purchasePrice; }
    public double getSellingPrice() { return sellingPrice; }
    public void setSellingPrice(double sellingPrice) { this.sellingPrice = sellingPrice; }
    public double getStock() { return stock; }
    public void setStock(double stock) { this.stock = stock; }
    public double getMinimumStock() { return minimumStock; }
    public void setMinimumStock(double minimumStock) { this.minimumStock = minimumStock; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
