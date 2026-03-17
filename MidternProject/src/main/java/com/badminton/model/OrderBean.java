package com.badminton.model;

import java.time.LocalDateTime;

public class OrderBean {
	private Integer orderId;
	private Integer memberId;
	private LocalDateTime orderDate;
	private Integer totalAmount;
	private String status;
	private String paymentType;
	private String note;
	private LocalDateTime createdAt;
	
	//無參數建構子
	public OrderBean() {
		
	}
	
	// 全參數建構子
	public OrderBean(Integer orderId, Integer memberId, LocalDateTime orderDate,
			Integer totalAmount, String status, String paymentType, String note, 
			LocalDateTime createdAt) {
		this.orderId = orderId;
		this.memberId = memberId;
		this.orderDate = orderDate;
		this.totalAmount = totalAmount;
		this.status = status;
		this.paymentType = paymentType;
		this.note = note;
		this.createdAt = createdAt;
	}

	public Integer getOrderId() {
		return orderId;
	}

	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}

	public Integer getMemberId() {
		return memberId;
	}

	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}

	public LocalDateTime getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(LocalDateTime orderDate) {
		this.orderDate = orderDate;
	}

	public Integer getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(Integer totalAmount) {
		this.totalAmount = totalAmount;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPaymentType() {
		return paymentType;
	}

	public void setPaymentType(String paymentType) {
		this.paymentType = paymentType;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	@Override
	public String toString() {
		return "OrderBean [orderId=" + orderId + ", memberId=" + memberId + ", orderDate=" + orderDate
				+ ", totalAmount=" + totalAmount + ", status=" + status + ", paymentType=" + paymentType + ", note="
				+ note + ", createdAt=" + createdAt + "]";
	}
	
	

}
