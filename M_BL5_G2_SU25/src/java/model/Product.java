/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.ArrayList;
import java.util.List;

public class Product {
    private int productId;
    private String productName;
    private String status;
    private int categoryId;
    private String categoryName;
    private int brandId;
    private String brandName;
    private int supplierId;
    private String supplierName;
    private List<ProductVariant> variants = new ArrayList<>();

    // Constructors
    public Product() {}
    public Product(int productId, String productName, String status, int categoryId, String categoryName, 
                   int brandId, String brandName, int supplierId, String supplierName, List<ProductVariant> variants) {
        this.productId = productId;
        this.productName = productName;
        this.status = status;
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.brandId = brandId;
        this.brandName = brandName;
        this.supplierId = supplierId;
        this.supplierName = supplierName;
        this.variants = variants;
    }

    // Getters and Setters
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public int getBrandId() { return brandId; }
    public void setBrandId(int brandId) { this.brandId = brandId; }
    public String getBrandName() { return brandName; }
    public void setBrandName(String brandName) { this.brandName = brandName; }
    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }
    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }
    public List<ProductVariant> getVariants() { return variants; }
    public void setVariants(List<ProductVariant> variants) { this.variants = variants; }
}