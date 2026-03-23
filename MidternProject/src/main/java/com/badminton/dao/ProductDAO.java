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
}