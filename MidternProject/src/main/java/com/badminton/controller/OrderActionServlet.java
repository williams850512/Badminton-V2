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
        } else {
            // 如果遇到不認識的指令，回傳錯誤代碼
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

    /** 同時更新狀態 / 付款方式 / 備註（搭配 AJAX） */
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

            // 🔥 魔法二：因為前端是用 fetch，我們只要回傳成功代碼 (200 OK)，不用 sendRedirect
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"success\": true}");

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
            // 先刪除明細，再刪除主訂單 (避免 Foreign Key 衝突)
            orderItemDAO.deleteByOrderId(orderId);
            orderDAO.delete(orderId);
            
            System.out.println("🗑 資料庫已刪除: 訂單 #" + orderId);

            // 一樣只回傳成功訊號，不重載頁面
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"success\": true}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}