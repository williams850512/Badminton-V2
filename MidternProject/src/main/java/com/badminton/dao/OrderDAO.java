package com.badminton.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.badminton.model.OrderBean;
import com.badminton.util.DBConnection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;



import com.badminton.model.OrderBean;
import com.badminton.util.DBConnection;

public class OrderDAO {
	/*
	 * 新增一筆訂單
	 */
	public boolean insertWithConnection(Connection conn, OrderBean order) {
		//public boolean insert(OrderBean order) {
		String sql = "INSERT INTO orders (member_id, total_amount, status, payment_type, note) VALUES (?,?,?,?,?)";
		
		
		
		try (
			 PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			
			ps.setInt(1, order.getMemberId());
			ps.setInt(2, order.getTotalAmount() != null ? order.getTotalAmount() : 0);
			ps.setString(3, order.getStatus() != null ? order.getStatus() : "PENDING");
			ps.setString(4, order.getPaymentType());
			ps.setString(5, order.getNote());
			
			int affectedRows = ps.executeUpdate();
			
			if (affectedRows > 0) {
				try (ResultSet rs = ps.getGeneratedKeys()) {
					if (rs.next()) {
						order.setOrderId(rs.getInt(1)); // 把資料庫自動產生的 ID 寫回 Bean 裡面
					}
				}
				return true; // 新增成功
			}
		} catch (SQLException e) {
			e.printStackTrace(); // 印出錯誤訊息
		}
		return false; // 新增失敗
	}
	/*
	 * 查詢所有訂單
	 */
	public List<OrderBean> findAll() {
		List<OrderBean> list = new ArrayList<>();
		String sql = "SELECT * FROM orders ORDER BY created_at DESC";
		
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql);
			 ResultSet rs = ps.executeQuery()) {
			
			while (rs.next()) {
				OrderBean o = new OrderBean(); // 每找到一筆資料，就準備一個新的空便當盒 (Bean)
				o.setOrderId(rs.getInt("id"));
				o.setMemberId(rs.getInt("member_id"));
				
				if (rs.getTimestamp("order_date") != null) {
					o.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
				}
				
				o.setTotalAmount(rs.getInt("total_amount"));
				o.setStatus(rs.getString("status"));
				o.setPaymentType(rs.getString("payment_type"));
				o.setNote(rs.getString("note"));
				
				if (rs.getTimestamp("created_at") != null) {
					o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
				}
				
				list.add(o); // 把裝好菜的便當放進清單裡
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list; // 把整疊便當交出去
	}
	/*
	 * 依據 ID 查詢單筆訂單
	 */
	public OrderBean findById(int orderId) {
		String sql = "SELECT * FROM orders WHERE id = ?";
		
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			
			ps.setInt(1, orderId); // 把問號替換成我們要找的 ID
			
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) { // 如果有找到這筆資料
					OrderBean o = new OrderBean();
					o.setOrderId(rs.getInt("id"));
					o.setMemberId(rs.getInt("member_id"));
					
					if (rs.getTimestamp("order_date") != null) {
						o.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
					}
					
					o.setTotalAmount(rs.getInt("total_amount"));
					o.setStatus(rs.getString("status"));
					o.setPaymentType(rs.getString("payment_type"));
					o.setNote(rs.getString("note"));
					
					if (rs.getTimestamp("created_at") != null) {
						o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
					}
					return o; // 回傳這個找好的便當
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null; // 找不到就回傳空 (null)
	}
	/*
	 * 更新訂單狀態 (例如: 付款完成、取消訂單)
	 */
	public boolean updateStatus(int orderId, String status) {
		String sql = "UPDATE orders SET status = ? WHERE id = ?";
		
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			
			ps.setString(1, status); // 第一個問號
			ps.setInt(2, orderId);   // 第二個問號
			
			return ps.executeUpdate() > 0; // 如果有更新到資料(大於0行)，就代表成功(true)
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	/*
	 * 刪除訂單
	 */
	public boolean delete(int orderId) {
		String sql = "DELETE FROM orders WHERE id = ?";
		
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			
			ps.setInt(1, orderId);
			return ps.executeUpdate() > 0; // 如果有刪掉資料(大於0行)，就代表成功(true)
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	/* === 以下為測試專用區塊 ===
		public static void main(String[] args) {
			OrderDAO dao = new OrderDAO();
			
			System.out.println("⏳ 準備新增主訂單 (Order) 到資料庫...");
			
			// 1. 準備一份「主訂單」的假資料
			OrderBean newOrder = new OrderBean();
			newOrder.setMemberId(1); // 假設會員 ID 是 1
			newOrder.setTotalAmount(6000); // 對應剛剛商品明細的小計
			newOrder.setPaymentType("信用卡"); 
			newOrder.setNote("這是測試用的訂單，請送達管理室");
			
			// 2. 叫倉管員負責去放這張主訂單
			boolean isInsertSuccess = dao.insertWithConnection(conn,order);
			//boolean isInsertSuccess = dao.insert(newOrder);
			
			// public boolean insert(OrderBean order) => dao.insert(newOrder) 單純測試用
			// public boolean insertWithConnection(Connection conn, OrderBean order)=> insertWithConnection(conn, )給Service用(交易)
			
			// 3. 檢查測試結果
			if (isInsertSuccess) {
				System.out.println("✅ 主訂單新增成功！");
				// OrderDAO.insert() 裡面有寫 Statement.RETURN_GENERATED_KEYS，會自動抓取資料庫產生的流水號
				System.out.println("🎉 資料庫分配給這筆訂單的專屬 ID (order_id) 是：" + newOrder.getOrderId());
				System.out.println("💡 接下來你可以把這個專屬 ID，拿去填在 OrderItemDAO 的假便當裡測試！");
			} else {
				System.out.println("❌ 新增失敗！請往上檢查 Console 的 Exception 紅字，通常是欄位不符或是會員 ID 不存在。");
			}
		}
		*/
}

			
			
		
	


