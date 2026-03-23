package com.badminton.controller;

import java.io.IOException;
import com.badminton.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/api/bulkUpdateStatus")
public class OrderBulkUpdateStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String[] orderIds = request.getParameterValues("orderIds");
        String status = request.getParameter("status"); // 接收目標狀態
        
        response.setContentType("application/json;charset=UTF-8");

        if (orderIds != null && orderIds.length > 0 && status != null && !status.isEmpty()) {
            boolean success = orderDAO.updateStatusMultiple(orderIds, status);
            if (success) {
                response.getWriter().print("{\"success\": true, \"message\": \"成功將 " + orderIds.length + " 筆訂單更改為 " + status + "！\"}");
            } else {
                response.getWriter().print("{\"success\": false, \"message\": \"狀態更新失敗，請檢查資料庫。\"}");
            }
        } else {
            response.getWriter().print("{\"success\": false, \"message\": \"參數不完整，無法執行批次更新。\"}");
        }
    }
}