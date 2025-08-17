/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class ProductImage {
    private int productImageId;
    private String src;
    private String alt;
    private int productVariantId;

    // Constructors
    public ProductImage() {}
    public ProductImage(int productImageId, String src, String alt, int productVariantId) {
        this.productImageId = productImageId;
        this.src = src;
        this.alt = alt;
        this.productVariantId = productVariantId;
    }

    // Getters and Setters
    public int getProductImageId() { return productImageId; }
    public void setProductImageId(int productImageId) { this.productImageId = productImageId; }
    public String getSrc() { return src; }
    public void setSrc(String src) { this.src = src; }
    public String getAlt() { return alt; }
    public void setAlt(String alt) { this.alt = alt; }
    public int getProductVariantId() { return productVariantId; }
    public void setProductVariantId(int productVariantId) { this.productVariantId = productVariantId; }
}