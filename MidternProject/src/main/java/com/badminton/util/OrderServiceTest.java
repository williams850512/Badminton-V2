package com.badminton.util;

import java.util.List;

import com.badminton.dao.OrderDAO;
import com.badminton.dao.OrderItemDAO;
import com.badminton.model.OrderBean;
import com.badminton.model.OrderItemBean;
import com.badminton.service.OrderService;

public class OrderServiceTest {

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
	        
	     // ========== 查詢測試 (Read) ==========
	        System.out.println("\n--- 查詢所有訂單 ---");
	        OrderDAO dao = new OrderDAO();

	        java.util.List<OrderBean> allOrders = dao.findAll();
	        System.out.println("共查到 " + allOrders.size() + " 筆訂單：");
	        for (OrderBean o : allOrders) {
	            System.out.println("  訂單 #" + o.getOrderId()
	                + " | 會員:" + o.getMemberId()
	                + " | 金額:" + o.getTotalAmount()
	                + " | 狀態:" + o.getStatus()
	                + " | 時間:" + o.getCreatedAt());
	        }

	        // 查單筆（換成剛才新增的那筆 ID）
	        int testId = allOrders.get(0).getOrderId();  // 自動取第一筆的 ID
	        OrderBean single = dao.findById(testId);
	        System.out.println("\n查單筆 #" + testId + " => " + single);

	        // ========== 更新測試 (Update) ==========
	        System.out.println("\n--- 更新訂單狀態 ---");
	        boolean updated = dao.updateStatus(testId, "PAID");
	        System.out.println("更新狀態結果：" + (updated ? "✅ 成功 → PAID" : "❌ 失敗"));

	        // ========== 刪除測試 (Delete) ==========
	        // ⚠️ 先刪明細，再刪主訂單！
	        System.out.println("\n--- 刪除訂單 ---");
	        OrderItemDAO itemDao = new OrderItemDAO();
	        boolean itemsDeleted = itemDao.deleteByOrderId(testId);
	        boolean orderDeleted = dao.delete(testId);
	        System.out.println("刪明細：" + (itemsDeleted ? "✅ 成功" : "⚠️ 無明細或失敗"));
	        System.out.println("刪主訂單：" + (orderDeleted ? "✅ 成功" : "❌ 失敗"));


	    }
}