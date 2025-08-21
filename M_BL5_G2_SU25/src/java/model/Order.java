/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author tayho
 */
public class Order {
	private int orderId;
	private java.sql.Date orderDate;
	private String status;
	private Customer customer;
	private Employee createdBy;
	private Employee saleBy;
	private Store store;
	private java.util.List<OrderDetail> orderDetails;

	public Order() {}

	public Order(int orderId, java.sql.Date orderDate, String status, Customer customer, Employee createdBy, Employee saleBy, Store store, java.util.List<OrderDetail> orderDetails) {
		this.orderId = orderId;
		this.orderDate = orderDate;
		this.status = status;
		this.customer = customer;
		this.createdBy = createdBy;
		this.saleBy = saleBy;
		this.store = store;
		this.orderDetails = orderDetails;
	}

	public int getOrderId() { return orderId; }
	public void setOrderId(int orderId) { this.orderId = orderId; }
	public java.sql.Date getOrderDate() { return orderDate; }
	public void setOrderDate(java.sql.Date orderDate) { this.orderDate = orderDate; }
	public String getStatus() { return status; }
	public void setStatus(String status) { this.status = status; }
	public Customer getCustomer() { return customer; }
	public void setCustomer(Customer customer) { this.customer = customer; }
	public Employee getCreatedBy() { return createdBy; }
	public void setCreatedBy(Employee createdBy) { this.createdBy = createdBy; }
	public Employee getSaleBy() { return saleBy; }
	public void setSaleBy(Employee saleBy) { this.saleBy = saleBy; }
	public Store getStore() { return store; }
	public void setStore(Store store) { this.store = store; }
	public java.util.List<OrderDetail> getOrderDetails() { return orderDetails; }
	public void setOrderDetails(java.util.List<OrderDetail> orderDetails) { this.orderDetails = orderDetails; }
}
