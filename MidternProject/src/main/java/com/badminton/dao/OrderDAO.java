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
	    // 更新訂單基本資訊，並自動根據 OrderItems 重新計算 total_amount
	    String sql = "UPDATE Orders SET status = ?, payment_type = ?, note = ?, " +
	                 "total_amount = (SELECT ISNULL(SUM(quantity * unit_price), 0) FROM OrderItems WHERE order_id = ?) " +
	                 "WHERE order_id = ?";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	    	
	        ps.setString(1, status);
	        ps.setString(2, paymentType);
	        ps.setString(3, note);
	        ps.setInt(4, orderId);
	        ps.setInt(5, orderId);

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
	
	/*
	 * 🚀 終極嵌套版：同時寫入多張訂單與對應的商品明細 (含 Transaction & Subtotal)
	 */
	public String createMultipleOrdersWithItems(String[] memberIds, String[] paymentTypes, String[] notes,
												 String[] itemOrderIndexes, String[] itemProductIds,
												 String[] itemQuantities, String[] itemUnitPrices) {
		
		// 準備 SQL 語法 (total_amount 會由後端動態計算後寫入)
		String insertOrderSql = "INSERT INTO Orders (member_id, payment_type, note, status, total_amount) VALUES (?, ?, ?, 'PENDING', ?)";
		// ✨ 加上 subtotal 欄位與第 5 個問號
		String insertItemSql = "INSERT INTO OrderItems (order_id, product_id, quantity, unit_price, subtotal) VALUES (?, ?, ?, ?, ?)";

		try (Connection conn = DBConnection.getConnection()) {
			// 🔥 開啟 Transaction 防護罩：只要其中一筆失敗，全部還原！
			conn.setAutoCommit(false); 

			// 注意：主訂單的 PreparedStatement 必須加上 RETURN_GENERATED_KEYS 來拿自動生成的 ID
			try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSql, java.sql.Statement.RETURN_GENERATED_KEYS);
				 PreparedStatement psItem = conn.prepareStatement(insertItemSql)) {

				// 迴圈一：遍歷前端傳來的每一張主訂單
				for (int i = 0; i < memberIds.length; i++) {
					
					// 1. 先從明細陣列中，計算出這張訂單的「總金額」
					int totalAmount = 0;
					if (itemOrderIndexes != null) {
						for (int j = 0; j < itemOrderIndexes.length; j++) {
							if (Integer.parseInt(itemOrderIndexes[j]) == i) {
								totalAmount += (Integer.parseInt(itemQuantities[j]) * Integer.parseInt(itemUnitPrices[j]));
							}
						}
					}

					// 2. 寫入主訂單
					psOrder.setInt(1, Integer.parseInt(memberIds[i]));
					psOrder.setString(2, paymentTypes[i]);
					psOrder.setString(3, notes[i] == null ? "" : notes[i]);
					psOrder.setInt(4, totalAmount);
					psOrder.executeUpdate();

					// 3. 抓取資料庫剛剛自動給這張訂單的 ID
					int newOrderId = -1;
					try (ResultSet rs = psOrder.getGeneratedKeys()) {
						if (rs.next()) {
							newOrderId = rs.getInt(1);
						} else {
							throw new java.sql.SQLException("無法取得新增的訂單 ID");
						}
					}

					// 4. 迴圈二：找出屬於這張訂單的商品明細，綁上剛剛拿到的 newOrderId 並寫入
					if (itemOrderIndexes != null) {
						for (int j = 0; j < itemOrderIndexes.length; j++) {
							// 判斷這個明細的 Index 是否等於目前正在處理的訂單 Index (i)
							if (Integer.parseInt(itemOrderIndexes[j]) == i) {
								int qty = Integer.parseInt(itemQuantities[j]);
								int price = Integer.parseInt(itemUnitPrices[j]);
								int subtotal = qty * price; // ✨ 計算小計
								
								psItem.setInt(1, newOrderId);
								psItem.setInt(2, Integer.parseInt(itemProductIds[j]));
								psItem.setInt(3, qty);
								psItem.setInt(4, price);
								psItem.setInt(5, subtotal); // ✨ 塞入小計
								psItem.addBatch(); // 先加進批次清單
							}
						}
					}
					psItem.executeBatch(); // 把這張訂單的明細一次倒進資料庫
				}

				// 走到這裡代表所有訂單跟明細都沒報錯，完美 Commit！
				conn.commit(); 
				return "SUCCESS"; // ✨ 成功回傳字串

			} catch (Exception e) {
				conn.rollback(); // 發生任何錯誤，時光倒流
				e.printStackTrace();
				return e.getMessage(); // ✨ 失敗回傳真實 SQL 錯誤
			} finally {
				conn.setAutoCommit(true); // 恢復預設
			}

		} catch (Exception e) {
			e.printStackTrace();
			return "資料庫連線異常: " + e.getMessage();
		}
	}
}