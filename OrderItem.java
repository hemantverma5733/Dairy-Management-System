package com.smartdairy.model;

public class OrderItem {
    private int id;
    private int orderId;
    private int productId;
    private double quantity;
    private double price;
    private double total;

    public OrderItem() {}
    public OrderItem(int productId, double quantity, double price) {
        this.productId = productId;
        this.quantity = quantity;
        this.price = price;
        this.total = quantity * price;
    }
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public double getQuantity() { return quantity; }
    public void setQuantity(double quantity) { this.quantity = quantity; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }
}
