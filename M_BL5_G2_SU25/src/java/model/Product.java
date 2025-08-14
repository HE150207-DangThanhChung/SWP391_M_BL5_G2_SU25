/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author tayho
 */
public class Product {
    private int productId;
    private String productName;
    private int brandId;
    private String brandName;
    private int categoryId;
    private String categoryName;
    private String productCode;
    private double price;
    private int quantity;
    private String status;

    // Constructor for listing (includes brand and category names)
    public Product(int productId, String productName, int brandId, String brandName, int categoryId, String categoryName,
                   String productCode, double price, int quantity, String status) {
        this.productId = productId;
        this.productName = productName;
        this.brandId = brandId;
        this.brandName = brandName;
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.productCode = productCode;
        this.price = price;
        this.quantity = quantity;
        this.status = status;
    }

    // Constructor for adding (minimal fields)
    public Product(String productName, int brandId, int categoryId, String productCode, double price, int quantity, String status) {
        this.productName = productName;
        this.brandId = brandId;
        this.categoryId = categoryId;
        this.productCode = productCode;
        this.price = price;
        this.quantity = quantity;
        this.status = status;
    }

    // Getters and setters
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public int getBrandId() { return brandId; }
    public void setBrandId(int brandId) { this.brandId = brandId; }
    public String getBrandName() { return brandName; }
    public void setBrandName(String brandName) { this.brandName = brandName; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
