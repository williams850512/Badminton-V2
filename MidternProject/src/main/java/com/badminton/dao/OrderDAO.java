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
				o.setOrderId(rs.getInt("order_id"));
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
		String sql = "SELECT * FROM orders WHERE order_id = ?";
		
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			
			ps.setInt(1, orderId); // 把問號替換成我們要找的 ID
			
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) { // 如果有找到這筆資料
					OrderBean o = new OrderBean();
					o.setOrderId(rs.getInt("order_id"));
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
		String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
		
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
		String sql = "DELETE FROM orders WHERE order_id = ?";
		
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			
			ps.setInt(1, orderId);
			return ps.executeUpdate() > 0; // 如果有刪掉資料(大於0行)，就代表成功(true)
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	/* ─────────────────────────────────────────────────────
	 * 模糊搜尋 / 精準搜尋
	 * searchField: "all"         → 模糊搜尋 note + payment_type
	 *              "memberId"    → 精準 member_id
	 *              "status"      → 精準 status
	 *              "paymentType" → 精準 payment_type
	 *              "note"        → 模糊 note
	 * ───────────────────────────────────────────────────── */
	public List<OrderBean> findByKeyword(String keyword, String searchField) {
		List<OrderBean> list = new ArrayList<>();
		String sql;
		boolean isLike   = false;
		boolean isDouble = false;

		switch (searchField == null ? "all" : searchField) {
			case "memberId":
				sql = "SELECT * FROM orders WHERE member_id = ? ORDER BY created_at DESC";
				break;
			case "status":
				sql = "SELECT * FROM orders WHERE status = ? ORDER BY created_at DESC";
				break;
			case "paymentType":
				sql = "SELECT * FROM orders WHERE payment_type = ? ORDER BY created_at DESC";
				break;
			case "note":
				sql = "SELECT * FROM orders WHERE note LIKE ? ORDER BY created_at DESC";
				isLike = true;
				break;
			default: // "all"
				sql = "SELECT * FROM orders WHERE note LIKE ? OR payment_type LIKE ? ORDER BY created_at DESC";
				isLike   = true;
				isDouble = true;
				break;
		}

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {

			if (isDouble) {
				String like = "%" + keyword + "%";
				ps.setString(1, like);
				ps.setString(2, like);
			} else if (isLike) {
				ps.setString(1, "%" + keyword + "%");
			} else if ("memberId".equals(searchField)) {
				ps.setInt(1, Integer.parseInt(keyword.trim()));
			} else {
				ps.setString(1, keyword.trim());
			}

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(mapRow(rs));
				}
			}
		} catch (SQLException | NumberFormatException e) {
			e.printStackTrace();
		}
		return list;
	}

	/* ─────────────────────────────────────────────────────
	 * 同時更新訂單狀態 / 付款方式 / 備註，並記錄 updated_at
	 * ───────────────────────────────────────────────────── */
	public boolean updateOrder(int orderId, String status, String paymentType, String note) {
		String sql = "UPDATE orders "
				   + "SET status = ?, payment_type = ?, note = ?, updated_at = GETDATE() "
				   + "WHERE order_id = ?";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setString(2, paymentType);
			ps.setString(3, note);
			ps.setInt(4, orderId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	/* ResultSet 轉 OrderBean 的共用 helper */
	private OrderBean mapRow(ResultSet rs) throws SQLException {
		OrderBean o = new OrderBean();
		o.setOrderId(rs.getInt("order_id"));
		o.setMemberId(rs.getInt("member_id"));
		if (rs.getTimestamp("order_date") != null)
			o.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
		o.setTotalAmount(rs.getInt("total_amount"));
		o.setStatus(rs.getString("status"));
		o.setPaymentType(rs.getString("payment_type"));
		o.setNote(rs.getString("note"));
		if (rs.getTimestamp("created_at") != null)
			o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
		return o;
	}
}

			
			
		
	


