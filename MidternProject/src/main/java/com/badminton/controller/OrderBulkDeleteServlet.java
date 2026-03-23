package com.badminton.controller;

import java.io.IOException;
import com.badminton.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/api/bulkDeleteOrders")
public class OrderBulkDeleteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 接收前端傳來的一包 ID 陣列 (例如: ["1", "3", "5"])
        String[] orderIds = request.getParameterValues("orderIds");
        
        response.setContentType("application/json;charset=UTF-8");

        if (orderIds != null && orderIds.length > 0) {
            boolean success = orderDAO.deleteMultiple(orderIds);
            if (success) {
                response.getWriter().print("{\"success\": true, \"message\": \"成功刪除 " + orderIds.length + " 筆訂單！\"}");
            } else {
                response.getWriter().print("{\"success\": false, \"message\": \"刪除失敗，請檢查資料庫狀態。\"}");
            }
        } else {
            response.getWriter().print("{\"success\": false, \"message\": \"未接收到任何要刪除的訂單 ID。\"}");
        }
    }
}