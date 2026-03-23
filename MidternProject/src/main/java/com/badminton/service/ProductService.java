package com.badminton.service;

import java.io.File;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

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
        productBean.setStatus(request.getParameter("status"));
        productBean.setProductCreateAt(parseDate(request.getParameter("productCreateAt")));

        try {
            //取得上傳圖片
            Part filePart = request.getPart("image");

            if (filePart != null && filePart.getSize() > 0) {

                String fileName = filePart.getSubmittedFileName();

                // 防止重名
                fileName = System.currentTimeMillis() + "_" + fileName;

                // 存檔路徑
                String uploadPath = request.getServletContext().getRealPath("/images/products");

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // 寫入檔案
                filePart.write(uploadPath + File.separator + fileName);

                // 存 DB 路徑
                productBean.setImageUrl("images/products/" + fileName);
                System.out.println("uploadPath = " + uploadPath);

            } else {
                // 沒上傳圖片（可給預設圖）
                productBean.setImageUrl("images/products/default.png");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        productDao.insertProduct(productBean);
    }
    //模糊查詢
    public List<ProductBean> searchProductsByKeyword(String keyword) {
        ProductDao productDao = new ProductDao();
        return productDao.searchProductsByKeyword(keyword);
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
        productBean.setStatus(request.getParameter("status"));

        try {
            Part filePart = request.getPart("image");

            // 有上傳新圖片
            if (filePart != null && filePart.getSize() > 0) {

                String fileName = filePart.getSubmittedFileName();
                fileName = System.currentTimeMillis() + "_" + fileName;

                String uploadPath = request.getServletContext().getRealPath("/images/products");

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                filePart.write(uploadPath + File.separator + fileName);

                productBean.setImageUrl("images/products/" + fileName);

            } else {
                // 沒上傳新圖 → 用舊的
                String imageUrl = request.getParameter("imageUrl");

                if (imageUrl == null || imageUrl.trim().isEmpty()) {
                    imageUrl = "images/products/default.png";
                }

                productBean.setImageUrl(imageUrl);
            }

        } catch (Exception e) {
            e.printStackTrace();

            // fallback（避免壞掉）
            String imageUrl = request.getParameter("imageUrl");

            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                imageUrl = "images/products/default.png";
            }

            productBean.setImageUrl(imageUrl);
        }

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