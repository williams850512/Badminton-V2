package com.badminton.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import com.badminton.dao.OrderDAO;
import com.badminton.dao.OrderItemDAO;
import com.badminton.model.OrderBean;
import com.badminton.model.OrderItemBean;
import com.badminton.util.DBConnection;

public class OrderService {
	
	private OrderDAO orderDAO = new OrderDAO();
	private OrderItemDAO orderItemDAO = new OrderItemDAO();
	
	/*
	 * 
	 * 結帳方法: 建立主訂單 + 所有訂單明細 (Transaction 管理)
	 * 
	 * @param order 主訂單資料
	 * @param items 所有商品明細的清單
	 * @return 成功回傳 true, 失敗回傳 false
	 *
	 */
	public boolean checkout(OrderBean order, List<OrderItemBean> items) {
		try(Connection conn = DBConnection.getConnection()){
			conn.setAutoCommit(false);
			
			try {
				// ===步驟一:新增主訂單===
				boolean orderInserted = orderDAO.insertWithConnection(conn, order);
				
				if(!orderInserted || order.getOrderId() == null) {
					conn.rollback();
					System.out.print("❌ 建立主訂單失敗，交易已取消 (Rollback)。");
					return false;
				}
				
				int newOrderId = order.getOrderId();
				
				// ===步驟二:依序新增每一項商品明細===
				
				for (OrderItemBean item : items) {
					item.setOrderId(newOrderId);
					boolean itemInserted = orderItemDAO.insertWithConnection(conn, item);
					
					if(!itemInserted) {
						conn.rollback();
						System.out.println("❌ 建立訂單明細失敗，交易已取消 (Rollback)。");
						return false;
					}
				}
				
				// ===步驟三:所有動作都成功！正式存入資料庫！===
				conn.commit();
				System.out.println("✅ 結帳成功！訂單 ID：" + newOrderId + " 已正式寫入資料庫。");
				return true;
			} catch (SQLException e) {
				conn.rollback();
				e.printStackTrace();
				System.out.println("❌ 發生 SQL 例外，交易已取消 (Rollback)。");
				return false;
			}
			
		}catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	 // =====================================================================
    // === 以下為測試專用區塊 ===
    // =====================================================================
    public static void main(String[] args) {
        OrderService service = new OrderService();
        System.out.println("⏳ 開始測試 OrderService.checkout() ...");

        // 1. 準備主訂單 (注意：類別名稱是 Order，不是 OrderBean)
        OrderBean order = new OrderBean();
        order.setMemberId(1);         // 必須是 Members 表裡真實存在的 member_id
        order.setTotalAmount(6650);
        order.setPaymentType("信用卡");
        order.setNote("這是 Service 層的測試訂單！");

        // 2. 準備商品明細清單（類別名稱是 OrderItem，不是 OrderItermBean）
        java.util.List<OrderItemBean> items = new java.util.ArrayList<>();

        OrderItemBean item1 = new OrderItemBean();
        item1.setProductId(1);   // product_id=1 (YONEX ASTROX 88D PRO)
        item1.setQuantity(1);
        item1.setUnitPrice(5800);
        item1.setSubtotal(5800);
        items.add(item1);

        OrderItemBean item2 = new OrderItemBean();
        item2.setProductId(3);   // product_id=3 (YONEX AS-50 羽球)
        item2.setQuantity(1);
        item2.setUnitPrice(850);
        item2.setSubtotal(850);
        items.add(item2);

        // 3. 呼叫結帳！
        boolean result = service.checkout(order, items);

        if (result) {
            System.out.println("🎉 測試通過！請去 SQL Server 確認 Orders 和 OrderItems 兩張表都有新增資料。");
        } else {
            System.out.println("❌ 測試失敗，請查看上方的錯誤訊息。");
        }
    }

}
