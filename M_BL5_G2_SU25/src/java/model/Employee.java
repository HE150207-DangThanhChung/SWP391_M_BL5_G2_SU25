/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author tayho
 */
public class Employee {

    private int employeeId;
    private String userName;
    private String password;
    private String firstName;
    private String middleName;
    private String lastName;
    private String phone;
    private String email;
    private String cccd;
    private String status;
    private String avatar;
    private Date dob;
    private String address;
    private Date startAt;
    private String gender;
    private int roleId;
    private int storeId;
    
    private Integer wardId; 

    // Thuộc tính để hiện thị tốt hơn
    private String roleName;
    private String storeName;
    private String wardName;

    public Employee() {
    }

    public Employee(int employeeId, String userName, String password, String firstName, String middleName, String lastName, String phone, String email, String cccd, String status, String avatar, Date dob, String address, Date startAt, String gender, int roleId, int storeId, int wardId, String roleName, String storeName, String wardName) {
        this.employeeId = employeeId;
        this.userName = userName;
        this.password = password;
        this.firstName = firstName;
        this.middleName = middleName;
        this.lastName = lastName;
        this.phone = phone;
        this.email = email;
        this.cccd = cccd;
        this.status = status;
        this.avatar = avatar;
        this.dob = dob;
        this.address = address;
        this.startAt = startAt;
        this.gender = gender;
        this.roleId = roleId;
        this.storeId = storeId;
        this.wardId = wardId;
        this.roleName = roleName;
        this.storeName = storeName;
        this.wardName = wardName;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
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
    
    // Helper method to get full name
    public String getFullName() {
        StringBuilder fullName = new StringBuilder();
        if (firstName != null && !firstName.isEmpty()) {
            fullName.append(firstName).append(" ");
        }
        if (middleName != null && !middleName.isEmpty()) {
            fullName.append(middleName).append(" ");
        }
        if (lastName != null && !lastName.isEmpty()) {
            fullName.append(lastName);
        }
        return fullName.toString().trim();
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

    public String getCccd() {
        return cccd;
    }

    public void setCccd(String cccd) {
        this.cccd = cccd;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getStartAt() {
        return startAt;
    }

    public void setStartAt(Date startAt) {
        this.startAt = startAt;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public int getStoreId() {
        return storeId;
    }

    public void setStoreId(int storeId) {
        this.storeId = storeId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getStoreName() {
        return storeName;
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }

    public Integer getWardId() {
        return wardId;
    }

    public void setWardId(Integer wardId) {
        this.wardId = wardId;
    }

    public String getWardName() {
        return wardName;
    }

    public void setWardName(String wardName) {
        this.wardName = wardName;
    }
    

    @Override
    public String toString() {
        return "Employee{" + "employeeId=" + employeeId + ", userName=" + userName + ", password=" + password + ", firstName=" + firstName + ", middleName=" + middleName + ", lastName=" + lastName + ", phone=" + phone + ", email=" + email + ", cccd=" + cccd + ", status=" + status + ", avatar=" + avatar + ", dob=" + dob + ", address=" + address + ", startAt=" + startAt + ", gender=" + gender + ", roleId=" + roleId + ", storeId=" + storeId + ", roleName=" + roleName + ", storeName=" + storeName + '}';
    }

}
