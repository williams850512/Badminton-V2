package com.badminton.model;

public class OrderItermBean {
	private Integer itemId;
	private Integer orderId;
	private Integer productId;
	private Integer quantity;
	private Integer unitPrice;
	private Integer subtotal;
	
	// 無參數建構子
	public OrderItermBean() {
		
	}
	
	// 全參數建構子
	
	public OrderItermBean(
			Integer itemId, Integer orderId, Integer productId,
			Integer quantity, Integer uniPrice, Integer subtotal) {
		this.itemId = itemId;
		this.orderId = orderId;
		this.productId = productId;
		this.quantity = quantity;
		this.unitPrice = uniPrice;
		this.subtotal = subtotal;
	}

	public Integer getItemId() {
		return itemId;
	}

	public void setItemId(Integer itemId) {
		this.itemId = itemId;
	}

	public Integer getOrderId() {
		return orderId;
	}

	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}

	public Integer getProductId() {
		return productId;
	}

	public void setProductId(Integer productId) {
		this.productId = productId;
	}

	public Integer getQuantity() {
		return quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	public Integer getUnitPrice() {
		return unitPrice;
	}

	public void setUnitPrice(Integer unitPrice) {
		this.unitPrice = unitPrice;
	}

	public Integer getSubtotal() {
		return subtotal;
	}

	public void setSubtotal(Integer subtotal) {
		this.subtotal = subtotal;
	}

	@Override
	public String toString() {
		return "OrderItermBean [itemId=" + itemId + ", orderId=" + orderId + ", productId=" + productId + ", quantity="
				+ quantity + ", unitPrice=" + unitPrice + ", subtotal=" + subtotal + "]";
	}
	

}
