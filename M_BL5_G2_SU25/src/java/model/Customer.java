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
public class Customer {
    private int customerId;
    private String firstName;
    private String middleName;   
    private String lastName;
    private String phone;
    private String email;
    private String gender;
    private String address;
    private String status;
    private String taxCode;      
    private Integer wardId;      
    private Date dob;          
    private String fullName;

    // Convenience fields for display (joined from Ward & City)
    private String wardName;
    private String cityName;

    public Customer() {
    }

    public Customer(int customerId, String firstName, String middleName, String lastName, String phone, String email, String gender, String address, String status, String taxCode, Integer wardId, Date dob) {
        this.customerId = customerId;
        this.firstName = firstName;
        this.middleName = middleName;
        this.lastName = lastName;
        this.phone = phone;
        this.email = email;
        this.gender = gender;
        this.address = address;
        this.status = status;
        this.taxCode = taxCode;
        this.wardId = wardId;
        this.dob = dob;
    }
    // Derived display helper
    public String getFullName() {
        String m = (middleName == null || middleName.isBlank()) ? "" : (" " + middleName.trim());
        return (firstName == null ? "" : firstName.trim()) + m + " " + (lastName == null ? "" : lastName.trim());
    }
    
    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTaxCode() {
        return taxCode;
    }

    public void setTaxCode(String taxCode) {
        this.taxCode = taxCode;
    }

    public Integer getWardId() {
        return wardId;
    }

    public void setWardId(Integer wardId) {
        this.wardId = wardId;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getWardName() {
        return wardName;
    }

    public void setWardName(String wardName) {
        this.wardName = wardName;
    }

    public String getCityName() {
        return cityName;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }    
}
