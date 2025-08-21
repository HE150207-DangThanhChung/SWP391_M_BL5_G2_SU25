package model;

public class OrderDetail {
    private int orderId;
    private int productVariantId;
    private String productName;
    private double price;
    private int quantity;
    private Double discount;
    private Double taxRate;
    private double totalAmount;
    private String status;

    public OrderDetail() {}

    public OrderDetail(int orderId, int productVariantId, String productName, double price, int quantity, Double discount, Double taxRate, double totalAmount, String status) {
        this.orderId = orderId;
        this.productVariantId = productVariantId;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.discount = discount;
        this.taxRate = taxRate;
        this.totalAmount = totalAmount;
        this.status = status;
    }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getProductVariantId() { return productVariantId; }
    public void setProductVariantId(int productVariantId) { this.productVariantId = productVariantId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public Double getDiscount() { return discount; }
    public void setDiscount(Double discount) { this.discount = discount; }
    public Double getTaxRate() { return taxRate; }
    public void setTaxRate(Double taxRate) { this.taxRate = taxRate; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
