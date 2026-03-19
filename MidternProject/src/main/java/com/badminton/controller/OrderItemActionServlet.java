package com.badminton.controller;

import java.io.IOException;
import java.io.PrintWriter;

import com.badminton.dao.OrderItemDAO;

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

            boolean ok = orderItemDAO.updateItem(itemId, productId, quantity, unitPrice);
            if (ok) {
                out.print("{\"success\":true,\"subtotal\":" + subtotal
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
            boolean ok = orderItemDAO.deleteByItemId(itemId);
            out.print(ok
                ? "{\"success\":true,\"message\":\"明細 #" + itemId + " 已刪除\"}"
                : "{\"success\":false,\"message\":\"刪除失敗，明細可能不存在\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }
}
