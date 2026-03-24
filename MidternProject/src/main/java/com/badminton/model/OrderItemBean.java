package com.badminton.model;

public class OrderItemBean {
	private Integer itemId;
	private Integer orderId;
	private Integer productId;
	private String  productName;  // 從 Products 表 JOIN 取得，不存在 OrderItems
	private Integer quantity;
	private Integer unitPrice;
	private Integer subtotal;
	
	// 無參數建構子
	public OrderItemBean() {
		
	}
	
	// 全參數建構子
	
	public OrderItemBean(
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

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
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
		return "OrderItemBean [itemId=" + itemId + ", orderId=" + orderId
				+ ", productId=" + productId + ", productName=" + productName
				+ ", quantity=" + quantity + ", unitPrice=" + unitPrice
				+ ", subtotal=" + subtotal + "]";
	}
	

}
