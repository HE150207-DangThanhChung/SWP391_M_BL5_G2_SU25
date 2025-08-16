/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;

public class ProductVariant {
    private int productVariantId;
    private String productCode;
    private double price;
    private int warrantyDurationMonth;
    private int productId;
    private List<VariantSpecification> specifications;
    private List<ProductImage> images;
    private List<ProductSerial> serials;

    // Constructors
    public ProductVariant() {}
    public ProductVariant(int productVariantId, String productCode, double price, int warrantyDurationMonth, int productId, 
                          List<VariantSpecification> specifications, List<ProductImage> images, List<ProductSerial> serials) {
        this.productVariantId = productVariantId;
        this.productCode = productCode;
        this.price = price;
        this.warrantyDurationMonth = warrantyDurationMonth;
        this.productId = productId;
        this.specifications = specifications;
        this.images = images;
        this.serials = serials;
    }

    // Getters and Setters
    public int getProductVariantId() { return productVariantId; }
    public void setProductVariantId(int productVariantId) { this.productVariantId = productVariantId; }
    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getWarrantyDurationMonth() { return warrantyDurationMonth; }
    public void setWarrantyDurationMonth(int warrantyDurationMonth) { this.warrantyDurationMonth = warrantyDurationMonth; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public List<VariantSpecification> getSpecifications() { return specifications; }
    public void setSpecifications(List<VariantSpecification> specifications) { this.specifications = specifications; }
    public List<ProductImage> getImages() { return images; }
    public void setImages(List<ProductImage> images) { this.images = images; }
    public List<ProductSerial> getSerials() { return serials; }
    public void setSerials(List<ProductSerial> serials) { this.serials = serials; }
}
