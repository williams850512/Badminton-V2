package com.badminton.controller;

import java.io.IOException;

import com.badminton.dao.OrderDAO;
import com.badminton.dao.OrderItemDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * OrderActionServlet（AJAX 無縫升級版）
 */
@WebServlet("/orderAction")
@MultipartConfig // 🔥 魔法一：加上這個，Servlet 才能解析 JavaScript fetch 傳來的 FormData！
public class OrderActionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OrderDAO     orderDAO     = new OrderDAO();
    private OrderItemDAO orderItemDAO = new OrderItemDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        // 設定回傳格式為 JSON 或是純文字，不要回傳 HTML
        response.setContentType("application/json;charset=UTF-8"); 

        String action = request.getParameter("action");
        System.out.println("🔥 後端收到 Action: " + action); // Debug 追蹤

        if ("updateStatus".equals(action)) {
            handleUpdateStatus(request, response);
        } else if ("updateOrder".equals(action)) {
            handleUpdateOrder(request, response);
        } else if ("delete".equals(action)) {
            handleDelete(request, response);
        } 
        else if ("createBulkAdvanced".equals(action)) {
            handleCreateBulkAdvanced(request, response);
        } 
        else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    /** 只更新狀態（舊版相容） */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int    orderId   = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("status");
            orderDAO.updateStatus(orderId, newStatus);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/orderList");
    }

    private void handleUpdateOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int    orderId     = Integer.parseInt(request.getParameter("orderId"));
            String status      = request.getParameter("status");
            String paymentType = request.getParameter("paymentType");
            String note        = request.getParameter("note");

            boolean ok = orderDAO.updateOrder(orderId, status, paymentType, note);
            System.out.println(ok
                ? "✅ 資料庫已更新: 訂單 #" + orderId 
                : "❌ 資料庫更新失敗: 訂單 #" + orderId);

            // 更新成功後，重新查詢取得最新的 totalAmount
            int newTotal = 0;
            if (ok) {
                com.badminton.model.OrderBean updated = orderDAO.findById(orderId);
                if (updated != null && updated.getTotalAmount() != null) {
                    newTotal = updated.getTotalAmount();
                }
            }

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"success\": true, \"totalAmount\": " + newTotal + "}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /** 刪除訂單（搭配 AJAX） */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            orderItemDAO.deleteByOrderId(orderId);
            orderDAO.delete(orderId);
            
            System.out.println("🗑 資料庫已刪除: 訂單 #" + orderId);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"success\": true}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    // ✨ 處理終極巢狀批次建單的專屬方法
    private void handleCreateBulkAdvanced(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String[] memberIds = request.getParameterValues("memberIds");
            String[] paymentTypes = request.getParameterValues("paymentTypes");
            String[] notes = request.getParameterValues("notes");

            String[] itemOrderIndexes = request.getParameterValues("itemOrderIndexes");
            String[] itemProductIds = request.getParameterValues("itemProductIds");
            String[] itemQuantities = request.getParameterValues("itemQuantities");
            String[] itemUnitPrices = request.getParameterValues("itemUnitPrices");

            if (memberIds != null && memberIds.length > 0) {
                // ✨✨✨ 關鍵修正：用 String 去接，不是 boolean！
                String result = orderDAO.createMultipleOrdersWithItems(
                        memberIds, paymentTypes, notes,
                        itemOrderIndexes, itemProductIds, itemQuantities, itemUnitPrices
                );

                // ✨✨✨ 判斷回傳的字串是不是 "SUCCESS"
                if ("SUCCESS".equals(result)) {
                    System.out.println("✅ 資料庫已成功批次新增 " + memberIds.length + " 筆訂單！");
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("{\"success\": true}");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    // 把 SQL 錯誤訊息的引號換掉，避免破壞 JSON 格式
                    String safeErrorMsg = result.replace("\"", "'").replace("\n", " ").replace("\r", " ");
                    response.getWriter().write("{\"success\": false, \"message\": \"資料庫寫入失敗 ➔ " + safeErrorMsg + "\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"未接收到任何訂單資料\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"後端發生異常\"}");
        }
    }
}