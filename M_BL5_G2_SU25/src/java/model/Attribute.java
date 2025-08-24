package model;

import java.util.List;

public class Attribute {

    private int attributeId;
    private String attributeName;
    private List<AttributeOption> options;

    // Constructors
    public Attribute() {
    }

    public Attribute(int attributeId, String attributeName) {
        this.attributeId = attributeId;
        this.attributeName = attributeName;
    }

    // Getters and Setters
    public int getAttributeId() {
        return attributeId;
    }

    public void setAttributeId(int attributeId) {
        this.attributeId = attributeId;
    }

    public String getAttributeName() {
        return attributeName;
    }

    public void setAttributeName(String attributeName) {
        this.attributeName = attributeName;
    }

    public List<AttributeOption> getOptions() {
        return options;
    }

    public void setOptions(List<AttributeOption> options) {
        this.options = options;
    }
}
