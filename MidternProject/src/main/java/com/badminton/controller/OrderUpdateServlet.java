package com.badminton.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.badminton.dao.OrderDAO;

@WebServlet("/orderUpdate")
public class OrderUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        try {
            // 1. 接收前端表單傳來的更新資料
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            String paymentType = request.getParameter("paymentType");
            String note = request.getParameter("note");

            // 2. 呼叫 DAO 進行更新
            OrderDAO dao = new OrderDAO();
            boolean success = dao.updateOrder(orderId, status, paymentType, note);

            // 3. 導回訂單列表，並帶上成功或失敗的訊息
            if (success) {
                response.sendRedirect(request.getContextPath() + "/orderList?msg=update_success");
            } else {
                response.sendRedirect(request.getContextPath() + "/orderList?error=update_fail");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/orderList?error=system_error");
        }
    }
}

