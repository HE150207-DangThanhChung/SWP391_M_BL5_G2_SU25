package model;

import java.util.ArrayList;
import java.util.List;

public class ProductVariant {
    private int productVariantId;
    private String productCode;
    private double price;
    private int warrantyDurationMonth;
    private int productId;
    private String productName;
    private String status;
    private String categoryName;
    private String brandName;
    private String supplierName;
    private List<AttributeOption> attributes = new ArrayList<>();
    private List<ProductImage> images = new ArrayList<>();
    private List<ProductSerial> serials = new ArrayList<>();

    // Constructors
    public ProductVariant() {
    }

    public ProductVariant(int productVariantId, String productCode, double price, int warrantyDurationMonth, int productId) {
        this.productVariantId = productVariantId;
        this.productCode = productCode;
        this.price = price;
        this.warrantyDurationMonth = warrantyDurationMonth;
        this.productId = productId;
    }

    // Getters and Setters
    public int getProductVariantId() {
        return productVariantId;
    }

    public void setProductVariantId(int productVariantId) {
        this.productVariantId = productVariantId;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getWarrantyDurationMonth() {
        return warrantyDurationMonth;
    }

    public void setWarrantyDurationMonth(int warrantyDurationMonth) {
        this.warrantyDurationMonth = warrantyDurationMonth;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public List<AttributeOption> getAttributes() {
        return attributes;
    }

    public void setAttributes(List<AttributeOption> attributes) {
        this.attributes = attributes;
    }

    public List<ProductImage> getImages() {
        return images;
    }

    public void setImages(List<ProductImage> images) {
        this.images = images;
    }

    public List<ProductSerial> getSerials() {
        return serials;
    }

    public void setSerials(List<ProductSerial> serials) {
        this.serials = serials;
    }
}