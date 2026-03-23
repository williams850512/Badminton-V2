package com.badminton.model;

import java.math.BigDecimal;
import java.sql.Date;

public class ProductBean {
	
	
	private Integer productId;
	private String productName;
	private String category;
	private String brand;
	private BigDecimal price;
	private Integer stockQty;
	private String description;
	private String imageUrl;
	private String status;
	private Date productCreateAt;
	
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
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getBrand() {
		return brand;
	}
	public void setBrand(String brand) {
		this.brand = brand;
	}
	public BigDecimal getPrice() {
		return price;
	}
	public void setPrice(BigDecimal price) {
		this.price = price;
	}
	public Integer getStockQty() {
		return stockQty;
	}
	public void setStockQty(Integer stockQty) {
		this.stockQty = stockQty;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getImageUrl() {
		return imageUrl;
	}
	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Date getProductCreateAt() {
		return productCreateAt;
	}
	public void setProductCreateAt(Date productCreateAt) {
		this.productCreateAt = productCreateAt;
	}
	public ProductBean(Integer productId, String productName, String category, String brand, BigDecimal price,
			Integer stockQty, String description, String imageUrl, String status, Date productCreateAt) {
		super();
		this.productId = productId;
		this.productName = productName;
		this.category = category;
		this.brand = brand;
		this.price = price;
		this.stockQty = stockQty;
		this.description = description;
		this.imageUrl = imageUrl;
		this.status = status;
		this.productCreateAt = productCreateAt;
	}
	public ProductBean() {
		// TODO Auto-generated constructor stub
	}
	
	

	
	
	
	
	

}
