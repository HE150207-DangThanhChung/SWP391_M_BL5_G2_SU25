package model;

public class ProductSerial {
    private int productSerialId;
    private String serialNumber;
    private int productVariantId;
    private int storeId;
    private String storeName;
    private String createdAt;
    private String updatedAt;

    // Constructors
    public ProductSerial() {
    }

    public ProductSerial(int productSerialId, String serialNumber, int productVariantId, int storeId, String status) {
        this.productSerialId = productSerialId;
        this.serialNumber = serialNumber;
        this.productVariantId = productVariantId;
        this.storeId = storeId;
    }

    // Getters and Setters
    public int getProductSerialId() {
        return productSerialId;
    }

    public void setProductSerialId(int productSerialId) {
        this.productSerialId = productSerialId;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public int getProductVariantId() {
        return productVariantId;
    }

    public void setProductVariantId(int productVariantId) {
        this.productVariantId = productVariantId;
    }

    public int getStoreId() {
        return storeId;
    }

    public void setStoreId(int storeId) {
        this.storeId = storeId;
    }

    public String getStoreName() {
        return storeName;
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }
}