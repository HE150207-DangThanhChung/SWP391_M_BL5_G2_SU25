/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;

/**
 *
 * @author Hello
 */
public class Payments {
    private int PaymentID;
    private int OrderID;
    private String PaymentMethod;
    private String Price;
    private Date PaymentDate;
    private String PaymentStatus;
    private String TransactionCode;
    private int CustomerId;
    private String FirstName;
    private String MiddleName;
    private String LastName;

    public Payments(int PaymentID, int OrderID, String PaymentMethod, String Price, Date PaymentDate, String PaymentStatus, String TransactionCode, 
            int CustomerId, String FirstName, String MiddleName, String LastName) {
        this.PaymentID = PaymentID;
        this.OrderID = OrderID;
        this.PaymentMethod = PaymentMethod;
        this.Price = Price;
        this.PaymentDate = PaymentDate;
        this.PaymentStatus = PaymentStatus;
        this.TransactionCode = TransactionCode;
        this.CustomerId = CustomerId;
        this.FirstName = FirstName;
        this.MiddleName = MiddleName;
        this.LastName = LastName;
    }

    public Payments() {
    }

    public int getPaymentID() {
        return PaymentID;
    }

    public void setPaymentID(int PaymentID) {
        this.PaymentID = PaymentID;
    }

    public int getOrderID() {
        return OrderID;
    }

    public void setOrderID(int OrderID) {
        this.OrderID = OrderID;
    }

    public String getPaymentMethod() {
        return PaymentMethod;
    }

    public void setPaymentMethod(String PaymentMethod) {
        this.PaymentMethod = PaymentMethod;
    }

    public String getPrice() {
        return Price;
    }

    public void setPrice(String Price) {
        this.Price = Price;
    }

    public Date getPaymentDate() {
        return PaymentDate;
    }

    public void setPaymentDate(Date PaymentDate) {
        this.PaymentDate = PaymentDate;
    }

    public String getPaymentStatus() {
        return PaymentStatus;
    }

    public void setPaymentStatus(String PaymentStatus) {
        this.PaymentStatus = PaymentStatus;
    }

    public String getTransactionCode() {
        return TransactionCode;
    }

    public void setTransactionCode(String TransactionCode) {
        this.TransactionCode = TransactionCode;
    }

    @Override
    public String toString() {
        return "Payments{" + "PaymentID=" + PaymentID + ", OrderID=" + OrderID + ", PaymentMethod=" + PaymentMethod + 
               ", Price=" + Price + ", PaymentDate=" + PaymentDate + ", PaymentStatus=" + PaymentStatus + 
               ", TransactionCode=" + TransactionCode + ", CustomerId=" + CustomerId + 
               ", FirstName=" + FirstName + ", MiddleName=" + MiddleName + ", LastName=" + LastName + '}';
    }

    public int getCustomerId() {
        return CustomerId;
    }

    public void setCustomerId(int CustomerId) {
        this.CustomerId = CustomerId;
    }

    public String getFirstName() {
        return FirstName;
    }

    public void setFirstName(String FirstName) {
        this.FirstName = FirstName;
    }

    public String getMiddleName() {
        return MiddleName;
    }

    public void setMiddleName(String MiddleName) {
        this.MiddleName = MiddleName;
    }

    public String getLastName() {
        return LastName;
    }

    public void setLastName(String LastName) {
        this.LastName = LastName;
    }
    
}
