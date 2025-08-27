package model;

import java.sql.Timestamp;

public class OrderCoupon {
    private int orderId;
    private int couponId;
    private Timestamp appliedAt;
    private double appliedAmount;
    
    // Navigation properties
    private Order order;
    private Coupon coupon;
    
    public OrderCoupon() {
    }
    
    public OrderCoupon(int orderId, int couponId) {
        this.orderId = orderId;
        this.couponId = couponId;
        this.appliedAt = new Timestamp(System.currentTimeMillis());
    }
    
    public OrderCoupon(int orderId, int couponId, Timestamp appliedAt, double appliedAmount) {
        this.orderId = orderId;
        this.couponId = couponId;
        this.appliedAt = appliedAt;
        this.appliedAmount = appliedAmount;
    }

    // Getters and Setters
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getCouponId() {
        return couponId;
    }

    public void setCouponId(int couponId) {
        this.couponId = couponId;
    }

    public Timestamp getAppliedAt() {
        return appliedAt;
    }

    public void setAppliedAt(Timestamp appliedAt) {
        this.appliedAt = appliedAt;
    }

    public double getAppliedAmount() {
        return appliedAmount;
    }

    public void setAppliedAmount(double appliedAmount) {
        this.appliedAmount = appliedAmount;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public Coupon getCoupon() {
        return coupon;
    }

    public void setCoupon(Coupon coupon) {
        this.coupon = coupon;
    }
}
