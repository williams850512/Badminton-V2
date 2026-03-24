package com.badminton.controller;

import java.io.IOException;
import java.io.PrintWriter;

import com.badminton.dao.OrderItemDAO;
import com.badminton.dao.OrderDAO;
import com.badminton.model.OrderBean;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * OrderItemActionServlet
 *
 * POST /orderItemAction?action=updateItem    → 更新單筆商品明細
 * POST /orderItemAction?action=deleteItem    → 刪除單筆商品明細
 *
 * 回應格式：JSON（供前端 fetch 接收）
 */
@WebServlet("/orderItemAction")
@MultipartConfig // 🔥 魔法核心：補上這個，Servlet 才能聽懂前端 FormData 傳來的話！
public class OrderItemActionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OrderItemDAO orderItemDAO = new OrderItemDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        System.out.println("🔥 OrderItemAction 收到指令: " + action); // Debug 用

        if ("updateItem".equals(action)) {
            handleUpdateItem(request, out);
        } else if ("deleteItem".equals(action)) {
            handleDeleteItem(request, out);
        } else {
            out.print("{\"success\":false,\"message\":\"未知的 action\"}");
        }
        out.flush();
    }

    /** 更新單筆明細：productId、quantity、unitPrice（subtotal 自動計算） */
    private void handleUpdateItem(HttpServletRequest request, PrintWriter out) {
        try {
            int itemId    = Integer.parseInt(request.getParameter("itemId"));
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity  = Integer.parseInt(request.getParameter("quantity"));
            int unitPrice = Integer.parseInt(request.getParameter("unitPrice"));
            int subtotal  = quantity * unitPrice;
            String orderIdParam = request.getParameter("orderId");

            boolean ok = orderItemDAO.updateItem(itemId, productId, quantity, unitPrice);
            if (ok) {
                System.out.println("✅ 資料庫已更新: 明細 #" + itemId);
                // 重新計算訂單總金額
                int newTotal = recalcOrderTotal(orderIdParam);
                out.print("{\"success\":true,\"subtotal\":" + subtotal
                        + ",\"totalAmount\":" + newTotal
                        + ",\"message\":\"明細 #" + itemId + " 已更新\"}");
            } else {
                out.print("{\"success\":false,\"message\":\"更新失敗，請確認明細 ID\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }

    /** 刪除單筆明細 */
    private void handleDeleteItem(HttpServletRequest request, PrintWriter out) {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            String orderIdParam = request.getParameter("orderId");
            boolean ok = orderItemDAO.deleteByItemId(itemId);
            
            if (ok) {
                System.out.println("🗑 資料庫已刪除: 明細 #" + itemId);
                // 重新計算訂單總金額
                int newTotal = recalcOrderTotal(orderIdParam);
                out.print("{\"success\":true,\"totalAmount\":" + newTotal
                        + ",\"message\":\"明細 #" + itemId + " 已刪除\"}");
            } else {
                out.print("{\"success\":false,\"message\":\"刪除失敗，明細可能不存在\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }

    /** 重新計算指定訂單的 total_amount 並回傳新總額 */
    private int recalcOrderTotal(String orderIdParam) {
        if (orderIdParam == null || orderIdParam.isEmpty()) return 0;
        try {
            int orderId = Integer.parseInt(orderIdParam);
            OrderDAO orderDAO = new OrderDAO();
            // 利用 updateOrder 的 SQL 子查詢重算 total_amount
            OrderBean existing = orderDAO.findById(orderId);
            if (existing != null) {
                orderDAO.updateOrder(orderId, existing.getStatus(), existing.getPaymentType(), existing.getNote());
                OrderBean updated = orderDAO.findById(orderId);
                return (updated != null && updated.getTotalAmount() != null) ? updated.getTotalAmount() : 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}