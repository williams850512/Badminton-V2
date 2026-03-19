package com.badminton.controller;

import java.io.IOException;

import com.badminton.dao.OrderDAO;
import com.badminton.dao.OrderItemDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * OrderActionServlet（加強版）
 *
 * POST /orderAction?action=updateStatus  → 只更新狀態（保留相容性）
 * POST /orderAction?action=updateOrder   → 同時更新狀態 / 付款方式 / 備註 / updated_at
 * POST /orderAction?action=delete        → 刪除訂單（先刪明細）
 */
@WebServlet("/orderAction")
public class OrderActionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OrderDAO     orderDAO     = new OrderDAO();
    private OrderItemDAO orderItemDAO = new OrderItemDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            handleUpdateStatus(request, response);
        } else if ("updateOrder".equals(action)) {
            handleUpdateOrder(request, response);
        } else if ("delete".equals(action)) {
            handleDelete(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/orderList");
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

    /** 同時更新狀態 / 付款方式 / 備註（管理者詳情編輯用） */
    private void handleUpdateOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int    orderId     = Integer.parseInt(request.getParameter("orderId"));
            String status      = request.getParameter("status");
            String paymentType = request.getParameter("paymentType");
            String note        = request.getParameter("note");

            boolean ok = orderDAO.updateOrder(orderId, status, paymentType, note);
            System.out.println(ok
                ? "✅ 訂單 #" + orderId + " 已更新（狀態/付款/備註）"
                : "❌ 訂單 #" + orderId + " 更新失敗");

        } catch (Exception e) {
            e.printStackTrace();
        }
        // 導回列表（保留篩選條件）
        String ref = request.getHeader("Referer");
        response.sendRedirect(ref != null ? ref : request.getContextPath() + "/orderList");
    }

    /** 刪除訂單（先刪明細，再刪主訂單） */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            orderItemDAO.deleteByOrderId(orderId);
            orderDAO.delete(orderId);
            System.out.println("✅ 訂單 #" + orderId + " 已刪除");
        } catch (Exception e) {
            e.printStackTrace();
        }
        String ref = request.getHeader("Referer");
        if (ref != null && ref.contains("/orderList")) {
            // 去掉可能帶著的 orderId 參數，直接保留 status/keyword 等
            response.sendRedirect(ref.replaceAll("[&?]orderId=[^&]*", ""));
        } else {
            response.sendRedirect(request.getContextPath() + "/orderList");
        }
    }
}
