package model;

import java.sql.Date;

public class FormRequest {
    private int formRequestId;
    private String description;
    private String status;
    private Date createdAt;
    private int employeeId;
    private String employeeName;

    public FormRequest() {}

    public FormRequest(int formRequestId, String description, String status, Date createdAt, int employeeId, String employeeName) {
        this.formRequestId = formRequestId;
        this.description = description;
        this.status = status;
        this.createdAt = createdAt;
        this.employeeId = employeeId;
        this.employeeName = employeeName;
    }

    public int getFormRequestId() {
        return formRequestId;
    }

    public void setFormRequestId(int formRequestId) {
        this.formRequestId = formRequestId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public String getEmployeeName() {
        return employeeName;
    }

    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }

    @Override
    public String toString() {
        return "FormRequest{" +
                "formRequestId=" + formRequestId +
                ", description='" + description + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", employeeId=" + employeeId +
                ", employeeName='" + employeeName + '\'' +
                '}';
    }
} 