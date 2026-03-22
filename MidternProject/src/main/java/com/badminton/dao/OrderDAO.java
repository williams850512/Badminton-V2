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
	/*
	 * 批次刪除多筆訂單 (Bulk Delete - 支援連鎖刪除明細)
	 */
	public boolean deleteMultiple(String[] orderIds) {
		if (orderIds == null || orderIds.length == 0) return false;

		// 準備 SQL：依照陣列長度動態產生問號 (例如： ?, ?, ? )
		StringBuilder placeholders = new StringBuilder();
		for (int i = 0; i < orderIds.length; i++) {
			placeholders.append("?");
			if (i < orderIds.length - 1) placeholders.append(",");
		}
		String inClause = placeholders.toString();

		// ⚔️ 雙刀流 SQL 語法：先砍明細，再砍主訂單
		String sqlDeleteItems = "DELETE FROM OrderItems WHERE order_id IN (" + inClause + ")";
		String sqlDeleteOrders = "DELETE FROM Orders WHERE order_id IN (" + inClause + ")";

		try (Connection conn = DBConnection.getConnection()) {
			
			// 🔥 啟動交易防護罩：不成功，便成仁
			conn.setAutoCommit(false); 

			try (PreparedStatement psItems = conn.prepareStatement(sqlDeleteItems);
				 PreparedStatement psOrders = conn.prepareStatement(sqlDeleteOrders)) {

				// 步驟 1：把陣列裡的 ID 塞進「明細表」的問號裡，先把底下的小兵全砍了
				for (int i = 0; i < orderIds.length; i++) {
					psItems.setInt(i + 1, Integer.parseInt(orderIds[i].trim()));
				}
				psItems.executeUpdate(); // 砍掉明細 (即使這張單沒明細也沒關係，不會報錯)

				// 步驟 2：把陣列裡的 ID 塞進「主訂單表」的問號裡，現在可以安心砍主帥了
				for (int i = 0; i < orderIds.length; i++) {
					psOrders.setInt(i + 1, Integer.parseInt(orderIds[i].trim()));
				}
				int deletedOrders = psOrders.executeUpdate();

				// 步驟 3：雙殺成功，蓋章確認！
				conn.commit(); 
				return deletedOrders > 0;

			} catch (SQLException e) {
				// ❌ 萬一發生意外，資料庫時光倒流，什麼都不刪除
				conn.rollback();
				e.printStackTrace(); // 把真正的死因印在 Eclipse 裡
			} finally {
				conn.setAutoCommit(true); // 恢復預設設定
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	/*
	 * 批次修改多筆訂單狀態 (Bulk Update Status)
	 */
	public boolean updateStatusMultiple(String[] orderIds, String status) {
		if (orderIds == null || orderIds.length == 0) return false;

		// 準備 SQL：依照陣列長度動態產生問號
		StringBuilder placeholders = new StringBuilder();
		for (int i = 0; i < orderIds.length; i++) {
			placeholders.append("?");
			if (i < orderIds.length - 1) placeholders.append(",");
		}

		// 語法：UPDATE Orders SET status = ? WHERE order_id IN (?, ?, ?)
		String sql = "UPDATE Orders SET status = ? WHERE order_id IN (" + placeholders.toString() + ")";

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, status); // 第一個問號是目標狀態

			// 後面的問號是陣列裡的訂單 ID
			for (int i = 0; i < orderIds.length; i++) {
				ps.setInt(i + 2, Integer.parseInt(orderIds[i].trim()));
			}

			int updatedRows = ps.executeUpdate();
			return updatedRows > 0;

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
	 * 🔥 終極全能搜尋 (支援 #訂單、多筆逗號查詢、金額範圍)
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

		// 🌟 神級判斷 3：是否有逗號？而且去掉逗號、#、空白後，是不是純數字？ (例如: "1, 3, #5")
		boolean isBulkIdSearch = kw.contains(",") && kw.replaceAll("[#, ]", "").matches("\\d+");
		
		boolean isHashOrder = kw.startsWith("#") && kw.substring(1).matches("\\d+");
		boolean isNumeric = kw.matches("\\d+");

		List<Integer> bulkIds = new ArrayList<>();

		if (hasKeyword) {
			if (isBulkIdSearch) {
				// 處理逗號分隔字串
				String[] parts = kw.split(",");
				StringBuilder placeholders = new StringBuilder();
				for (String p : parts) {
					String cleanId = p.replaceAll("[# ]", ""); // 清除 # 和空白
					if (!cleanId.isEmpty()) {
						bulkIds.add(Integer.parseInt(cleanId));
						placeholders.append("?,");
					}
				}
				if (!bulkIds.isEmpty()) {
					placeholders.deleteCharAt(placeholders.length() - 1); // 刪掉最後一個逗號
					sql.append("AND o.order_id IN (" + placeholders.toString() + ") ");
				}
			} else if (isHashOrder) {
				sql.append("AND o.order_id = ? ");
			} else if (isNumeric) {
				sql.append("AND (o.order_id = ? OR o.member_id = ? OR o.note LIKE ? OR o.payment_type LIKE ? OR o.status LIKE ? OR p.product_name LIKE ?) ");
			} else {
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
				if (isBulkIdSearch && !bulkIds.isEmpty()) {
					// 塞入陣列裡的 ID
					for (Integer id : bulkIds) {
						ps.setInt(paramIndex++, id);
					}
				} else if (isHashOrder) {
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