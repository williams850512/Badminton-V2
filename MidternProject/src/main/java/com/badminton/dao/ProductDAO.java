package com.badminton.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.badminton.model.ProductBean;
import com.badminton.util.DBConnection;

public class ProductDAO {

    /**
     * 透過商品 ID 查詢商品 (僅限狀態為 active 的商品)
     */
    public ProductBean getProductById(int productId) {
        ProductBean product = null;
        // 使用 ? 參數化查詢防止 SQL Injection
        String sql = "SELECT product_id, product_name, price FROM Products WHERE product_id = ? AND status = 'active'";

        // 這裡使用 try-with-resources，執行完會自動關閉連線與資源
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, productId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    product = new ProductBean();
                    product.setProductId(rs.getInt("product_id"));
                    product.setProductName(rs.getString("product_name"));
                    product.setPrice(rs.getDouble("price"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return product;
    }

    /**
     * 透過商品名稱查詢商品 (精準比對，僅限狀態為 active)
     */
    public ProductBean getProductByName(String productName) {
        ProductBean product = null;
        String sql = "SELECT product_id, product_name, price FROM Products WHERE product_name = ? AND status = 'active'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, productName);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    product = new ProductBean();
                    product.setProductId(rs.getInt("product_id"));
                    product.setProductName(rs.getString("product_name"));
                    product.setPrice(rs.getDouble("price"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return product;
    }

    /**
     * 透過關鍵字模糊搜尋商品 (名稱或 ID，僅限 active)
     */
    public java.util.List<ProductBean> searchProducts(String keyword) {
        java.util.List<ProductBean> list = new java.util.ArrayList<>();
        // 嘗試把關鍵字當作 ID 處理
        String sql = "SELECT product_id, product_name, price FROM Products WHERE status = 'active' AND (product_name LIKE ? OR CAST(product_id AS NVARCHAR) LIKE ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String likeKeyword = "%" + keyword + "%";
            pstmt.setString(1, likeKeyword);
            pstmt.setString(2, likeKeyword);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ProductBean product = new ProductBean();
                    product.setProductId(rs.getInt("product_id"));
                    product.setProductName(rs.getString("product_name"));
                    product.setPrice(rs.getDouble("price"));
                    list.add(product);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}