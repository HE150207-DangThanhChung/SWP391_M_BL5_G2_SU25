/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;

/**
 *
 * @author tayho
 */
public class Coupon {
    private int couponId;
    private String couponCode;
    private double discountPercent;
    private double maxDiscount;
    private String requirement;
    private double minTotal;
    private int minProduct;
    private int applyLimit;
    private Date fromDate;
    private Date toDate;
    private String status;

    public Coupon() {
    }

    public Coupon(int couponId, String couponCode, double discountPercent, double maxDiscount, String requirement, double minTotal, int minProduct, int applyLimit, Date fromDate, Date toDate, String status) {
        this.couponId = couponId;
        this.couponCode = couponCode;
        this.discountPercent = discountPercent;
        this.maxDiscount = maxDiscount;
        this.requirement = requirement;
        this.minTotal = minTotal;
        this.minProduct = minProduct;
        this.applyLimit = applyLimit;
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.status = status;
    }

    public int getCouponId() {
        return couponId;
    }

    public void setCouponId(int couponId) {
        this.couponId = couponId;
    }

    public String getCouponCode() {
        return couponCode;
    }

    public void setCouponCode(String couponCode) {
        this.couponCode = couponCode;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public double getMaxDiscount() {
        return maxDiscount;
    }

    public void setMaxDiscount(double maxDiscount) {
        this.maxDiscount = maxDiscount;
    }

    public String getRequirement() {
        return requirement;
    }

    public void setRequirement(String requirement) {
        this.requirement = requirement;
    }

    public double getMinTotal() {
        return minTotal;
    }

    public void setMinTotal(double minTotal) {
        this.minTotal = minTotal;
    }

    public int getMinProduct() {
        return minProduct;
    }

    public void setMinProduct(int minProduct) {
        this.minProduct = minProduct;
    }

    public int getApplyLimit() {
        return applyLimit;
    }

    public void setApplyLimit(int applyLimit) {
        this.applyLimit = applyLimit;
    }

    public Date getFromDate() {
        return fromDate;
    }

    public void setFromDate(Date fromDate) {
        this.fromDate = fromDate;
    }

    public Date getToDate() {
        return toDate;
    }

    public void setToDate(Date toDate) {
        this.toDate = toDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
}
