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
				list.add(mapRow(rs)); 
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list; 
	}

	/*
	 * 依據 ID 查詢單筆訂單
	 */
	public OrderBean findById(int orderId) {
		String sql = "SELECT * FROM orders WHERE order_id = ?";
		
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			
			ps.setInt(1, orderId); 
			
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) { 
					return mapRow(rs);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null; 
	}

	/*
	 * 更新訂單狀態 
	 */
	public boolean updateStatus(int orderId, String status) {
		String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
		
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			
			ps.setString(1, status); 
			ps.setInt(2, orderId);   
			
			return ps.executeUpdate() > 0; 
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
			return ps.executeUpdate() > 0; 
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	/* ─────────────────────────────────────────────────────
	 * 舊版：模糊搜尋 / 精準搜尋 (保留以防萬一)
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
	 * 🔥 終極全能搜尋 (支援 #訂單搜尋 + 智慧數字判斷 + 金額)
	 * ───────────────────────────────────────────────────── */
	public List<OrderBean> findByAdvancedSearch(String keyword, Integer minPrice, Integer maxPrice) {
		List<OrderBean> list = new ArrayList<>();
		StringBuilder sql = new StringBuilder(
			"SELECT DISTINCT o.order_id, o.member_id, o.order_date, o.total_amount, " +
			"o.status, o.payment_type, o.note, o.created_at " +
			"FROM Orders o " +
			"LEFT JOIN OrderItems oi ON o.order_id = oi.order_id " +
			"LEFT JOIN Products p ON oi.product_id = p.product_id " +
			"WHERE 1=1 "
		);

		boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());
		String kw = hasKeyword ? keyword.trim() : "";

		// 🌟 神級判斷 1：是不是明確使用 # 來找訂單 (例如輸入 #16)
		boolean isHashOrder = kw.startsWith("#") && kw.substring(1).matches("\\d+");
		// 🌟 神級判斷 2：是不是純數字 (例如輸入 16)
		boolean isNumeric = kw.matches("\\d+");

		if (hasKeyword) {
			if (isHashOrder) {
				// 如果有加 #，我們認定他「只」想找該筆訂單 ID
				sql.append("AND o.order_id = ? ");
			} else if (isNumeric) {
				// 如果是純數字，精準找 ID，同時也去文字欄位模糊搜尋 (防呆)
				sql.append("AND (o.order_id = ? OR o.member_id = ? OR o.note LIKE ? OR o.payment_type LIKE ? OR o.status LIKE ? OR p.product_name LIKE ?) ");
			} else {
				// 純文字模糊搜尋
				sql.append("AND (o.note LIKE ? OR o.payment_type LIKE ? OR o.status LIKE ? OR p.product_name LIKE ?) ");
			}
		}
		
		if (minPrice != null) sql.append("AND o.total_amount >= ? ");
		if (maxPrice != null) sql.append("AND o.total_amount <= ? ");
		
		sql.append("ORDER BY o.created_at DESC");

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql.toString())) {

			int paramIndex = 1;
			if (hasKeyword) {
				if (isHashOrder) {
					// 把 "#16" 的 "#" 拔掉，只留 "16" 轉成數字去查
					ps.setInt(paramIndex++, Integer.parseInt(kw.substring(1))); 
				} else if (isNumeric) {
					int numKw = Integer.parseInt(kw);
					String likeKw = "%" + kw + "%";
					ps.setInt(paramIndex++, numKw);
					ps.setInt(paramIndex++, numKw);
					ps.setString(paramIndex++, likeKw);
					ps.setString(paramIndex++, likeKw);
					ps.setString(paramIndex++, likeKw);
					ps.setString(paramIndex++, likeKw);
				} else {
					String likeKw = "%" + kw + "%";
					ps.setString(paramIndex++, likeKw);
					ps.setString(paramIndex++, likeKw);
					ps.setString(paramIndex++, likeKw);
					ps.setString(paramIndex++, likeKw);
				}
			}
			if (minPrice != null) ps.setInt(paramIndex++, minPrice);
			if (maxPrice != null) ps.setInt(paramIndex++, maxPrice);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(mapRow(rs));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	/* ─────────────────────────────────────────────────────
	 * 同時更新訂單狀態 / 付款方式 / 備註，並記錄 updated_at
	 * ───────────────────────────────────────────────────── */
	public boolean updateOrder(int orderId, String status, String paymentType, String note) {
	    String sql = "UPDATE Orders SET status = ?, payment_type = ?, note = ? WHERE order_id = ?";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	    	
	        ps.setString(1, status);
	        ps.setString(2, paymentType);
	        ps.setString(3, note);
	        ps.setInt(4, orderId);

	        int rows = ps.executeUpdate();
	        return rows > 0;

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