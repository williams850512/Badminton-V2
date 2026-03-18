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
	/*
	 *  1. 新增訂單明細
	 *  
	 */
	public boolean insertWithConnection(Connection conn, OrderItemBean item) {
		String sql = "INSERT INTO OrderItems (order_id, product_id, quantity, unit_price, subtotal) VALUES (?,?,?,?,?)";
		
		try (
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, item.getOrderId());
			ps.setInt(2, item.getProductId());
			ps.setInt(3, item.getQuantity());
			ps.setInt(4, item.getUnitPrice());
			ps.setInt(5, item.getSubtotal());
			
			int affectedRows = ps.executeUpdate();
			return affectedRows > 0;
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	/*
	 * 2. 根據「訂單編號 (orderId)」查詢該筆訂單底下的所有商品明細
	 */
	public List<OrderItemBean> findByOrderId(int orderId){
		List<OrderItemBean> list = new ArrayList<>();
		
		String sql = "SELECT * FROM OrderItems WHERE order_id =?";
		try(Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, orderId);
			
			try(ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					OrderItemBean item = new OrderItemBean();
					
					item.setItemId(rs.getInt("item_id"));
					item.setOrderId(rs.getInt("order_id"));
					item.setProductId(rs.getInt("product_id"));
					item.setQuantity(rs.getInt("quantity"));
					item.setUnitPrice(rs.getInt("unit_price"));
					item.setSubtotal(rs.getInt("subtotal"));
					
					list.add(item); //把裝好菜的便當放進清單裡
					
				}
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list; //把裝滿明細的清單交出去!
	}
	/*
	 *  3. 刪除特定訂單的所有明細
	 */
	public boolean deleteByOrderId(int orderId) {
		String sql = "DELETE FROM OrderItems WHERE order_id =?";
		
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)){
			ps.setInt(1, orderId);
			int affectedRows = ps.executeUpdate();
			return affectedRows > 0;
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}
	/* === 以下為測試專用區塊 ===
		public static void main(String[] args) {
			OrderItemDAO dao = new OrderItemDAO();
			
			OrderItemBean testItem = new OrderItemBean();
			testItem.setOrderId(10);       // 假設屬於第 1 號訂單
			testItem.setProductId(5);   // 商品 ID
			testItem.setQuantity(2);      // 數量
			testItem.setUnitPrice(3000);  // 單價
			testItem.setSubtotal(6000);   // 小計
			
			// 叫倉管員把便當放進去 (剛剛上面也把 insert 接收的型態改為 OrderItem 了)
			boolean isSuccess = dao.insert(testItem);
			
			// dao.insert() 單純測試用
			// insertWithConnection()給Service用(交易)
			
			if (isSuccess) {
				System.out.println("✅ 新增明細成功！請打開 MySQL 檢查 order_items 資料表是否有這筆資料。");
			} else {
				System.out.println("❌ 新增失敗！請往上捲動檢查 Console 有沒有印出紅色的 Exception。");
			}
		}
		*/

}
