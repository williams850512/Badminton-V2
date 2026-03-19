package com.badminton.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.badminton.model.OrderItemBean;
import com.badminton.util.DBConnection;

public class OrderItemDAO {

    /* ─────────────────────────────────────────
     * 1. 新增訂單明細（交易版，給 OrderService 用）
     * ───────────────────────────────────────── */
    public boolean insertWithConnection(Connection conn, OrderItemBean item) throws SQLException {
        String sql = "INSERT INTO OrderItems (order_id, product_id, quantity, unit_price, subtotal)"
                   + " VALUES (?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getProductId());
            ps.setInt(3, item.getQuantity());
            ps.setInt(4, item.getUnitPrice());
            ps.setInt(5, item.getSubtotal());
            return ps.executeUpdate() > 0;
        }
        // SQLException 往上拋（交易控制在 Service 層）
    }

    /* ─────────────────────────────────────────
     * 2. 根據訂單 ID 查詢所有明細（JOIN Products 取商品名稱）
     * ───────────────────────────────────────── */
    public List<OrderItemBean> findByOrderId(int orderId) {
        List<OrderItemBean> list = new ArrayList<>();
        // LEFT JOIN：即使商品已被刪除也能顯示 item_id
        String sql = "SELECT oi.item_id, oi.order_id, oi.product_id, "
                   +        "p.product_name, oi.quantity, oi.unit_price, oi.subtotal "
                   + "FROM OrderItems oi "
                   + "LEFT JOIN Products p ON oi.product_id = p.product_id "
                   + "WHERE oi.order_id = ? "
                   + "ORDER BY oi.item_id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItemBean item = new OrderItemBean();
                    item.setItemId(rs.getInt("item_id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("product_name"));   // 來自 Products
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getInt("unit_price"));
                    item.setSubtotal(rs.getInt("subtotal"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /* ─────────────────────────────────────────
     * 3. 更新單筆明細（管理員調整用）
     *    小計由後端自動計算 = quantity × unit_price
     * ───────────────────────────────────────── */
    public boolean updateItem(int itemId, int productId, int quantity, int unitPrice) {
        int subtotal = quantity * unitPrice;
        String sql = "UPDATE OrderItems "
                   + "SET product_id = ?, quantity = ?, unit_price = ?, subtotal = ? "
                   + "WHERE item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, quantity);
            ps.setInt(3, unitPrice);
            ps.setInt(4, subtotal);
            ps.setInt(5, itemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ─────────────────────────────────────────
     * 4. 刪除單筆明細（by item_id）
     * ───────────────────────────────────────── */
    public boolean deleteByItemId(int itemId) {
        String sql = "DELETE FROM OrderItems WHERE item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ─────────────────────────────────────────
     * 5. 刪除某訂單的所有明細（刪主訂單前先呼叫）
     * ───────────────────────────────────────── */
    public boolean deleteByOrderId(int orderId) {
        String sql = "DELETE FROM OrderItems WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() >= 0;   // 允許回傳 0（訂單本無明細）
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
