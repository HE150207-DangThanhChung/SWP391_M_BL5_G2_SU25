/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author tayho
 */
public class Store {

    private int storeId;
    private String storeName;
    private String address;
    private String phone;
    private String status;
    
    public Store() { 
    }

    public Store(int storeId, String storeName, String address, String phone, String status) {
        this.storeId = storeId;
        this.storeName = storeName;
        this.address = address;
        this.phone = phone;
        this.status = status;
    }


    public int getStoreId() {
        return storeId;
    }

    public void setStoreId(int storeId) {
        this.storeId = storeId;
    }

    public String getStoreName() {
        return storeName;
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Store{" + "storeId=" + storeId + ", storeName=" + storeName + ", address=" + address + ", phone=" + phone + ", status=" + status + '}';
    }

    
}
