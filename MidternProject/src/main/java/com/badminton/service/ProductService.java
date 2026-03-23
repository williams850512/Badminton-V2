package com.badminton.service;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;

import com.badminton.dao.ProductDao;
import com.badminton.model.ProductBean;

public class ProductService {

    private ProductDao productDao = new ProductDao();

    // 查全部
    public List<ProductBean> showProduct() {
        return productDao.showProduct();
    }

    // 查單筆
    public ProductBean getProductById(Integer productId) {
        return productDao.searchProductById(productId);
    }

    // 新增
    public void insertProduct(HttpServletRequest request) {
        ProductBean productBean = new ProductBean();

        productBean.setProductName(request.getParameter("productName"));
        productBean.setCategory(request.getParameter("category"));
        productBean.setBrand(request.getParameter("brand"));
        productBean.setPrice(parseBigDecimal(request.getParameter("price")));
        productBean.setStockQty(parseInteger(request.getParameter("stockQty")));
        productBean.setDescription(request.getParameter("description"));
        productBean.setImageUrl(request.getParameter("imageUrl"));
        productBean.setStatus(request.getParameter("status"));
        productBean.setProductCreateAt(parseDate(request.getParameter("productCreateAt")));

        productDao.insertProduct(productBean);
    }

    // 修改
    public void updateProduct(HttpServletRequest request) {
        ProductBean productBean = new ProductBean();

        productBean.setProductId(parseInteger(request.getParameter("productId")));
        productBean.setProductName(request.getParameter("productName"));
        productBean.setCategory(request.getParameter("category"));
        productBean.setBrand(request.getParameter("brand"));
        productBean.setPrice(parseBigDecimal(request.getParameter("price")));
        productBean.setStockQty(parseInteger(request.getParameter("stockQty")));
        productBean.setDescription(request.getParameter("description"));
        productBean.setImageUrl(request.getParameter("imageUrl"));
        productBean.setStatus(request.getParameter("status"));

        productDao.updateProduct(productBean);
    }

    // 刪除
    public void deleteProduct(Integer productId) {
        productDao.deleteProduct(productId);
    }

    // ---------- 小工具方法 ----------
    private Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return Integer.parseInt(value.trim());
    }

    private BigDecimal parseBigDecimal(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return new BigDecimal(value.trim());
    }

    private Date parseDate(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return Date.valueOf(value.trim());
    }
}