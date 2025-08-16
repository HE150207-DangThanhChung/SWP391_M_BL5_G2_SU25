/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class Specification {
    private int specificationId;
    private String attributeName;

    // Constructors
    public Specification() {}
    public Specification(int specificationId, String attributeName) {
        this.specificationId = specificationId;
        this.attributeName = attributeName;
    }

    // Getters and Setters
    public int getSpecificationId() { return specificationId; }
    public void setSpecificationId(int specificationId) { this.specificationId = specificationId; }
    public String getAttributeName() { return attributeName; }
    public void setAttributeName(String attributeName) { this.attributeName = attributeName; }
}
