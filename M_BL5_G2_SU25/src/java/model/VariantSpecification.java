/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class VariantSpecification {
    private int productVariantId;
    private int specificationId;
    private String value;

    // Constructors
    public VariantSpecification() {}
    public VariantSpecification(int productVariantId, int specificationId, String value) {
        this.productVariantId = productVariantId;
        this.specificationId = specificationId;
        this.value = value;
    }

    // Getters and Setters
    public int getProductVariantId() { return productVariantId; }
    public void setProductVariantId(int productVariantId) { this.productVariantId = productVariantId; }
    public int getSpecificationId() { return specificationId; }
    public void setSpecificationId(int specificationId) { this.specificationId = specificationId; }
    public String getValue() { return value; }
    public void setValue(String value) { this.value = value; }
}
