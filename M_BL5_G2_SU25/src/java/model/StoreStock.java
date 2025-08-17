package model;

public class StoreStock {
    private int storeId;
    private int productVariantId;
    private int quantity;

    // Constructors
    public StoreStock() {}
    public StoreStock(int storeId, int productVariantId, int quantity) {
        this.storeId = storeId;
        this.productVariantId = productVariantId;
        this.quantity = quantity;
    }

    // Getters and Setters
    public int getStoreId() { return storeId; }
    public void setStoreId(int storeId) { this.storeId = storeId; }
    public int getProductVariantId() { return productVariantId; }
    public void setProductVariantId(int productVariantId) { this.productVariantId = productVariantId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}