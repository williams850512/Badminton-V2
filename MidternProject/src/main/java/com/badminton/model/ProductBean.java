package com.badminton.model;

public class ProductBean {
    private int productId;
    private String productName;
    private double price;

    // 預設建構子
    public ProductBean() {}

    // 帶參數的建構子
    public ProductBean(int productId, String productName, double price) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
    }

    // Getter 與 Setter
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}