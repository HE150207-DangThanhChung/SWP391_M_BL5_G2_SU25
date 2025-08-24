package model;

import com.google.gson.annotations.Expose;

public class AttributeOption {
    @Expose
    private int attributeOptionId;
    @Expose
    private String value;
    private Attribute attribute;

    // Constructors
    public AttributeOption() {
    }

    public AttributeOption(int attributeOptionId, String value, Attribute attribute) {
        this.attributeOptionId = attributeOptionId;
        this.value = value;
        this.attribute = attribute;
    }

    // Getters and Setters
    public int getAttributeOptionId() {
        return attributeOptionId;
    }

    public void setAttributeOptionId(int attributeOptionId) {
        this.attributeOptionId = attributeOptionId;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public Attribute getAttribute() {
        return attribute;
    }

    public void setAttribute(Attribute attribute) {
        this.attribute = attribute;
    }
}