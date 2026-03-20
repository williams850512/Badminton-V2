package com.badminton.controller;



import java.io.IOException;

import java.io.PrintWriter;



import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;

import jakarta.servlet.http.HttpServletRequest;

import jakarta.servlet.http.HttpServletResponse;



import com.badminton.dao.OrderItemDAO;



@WebServlet("/orderItemUpdate")

public class OrderItemUpdateServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;



    @Override

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 

            throws ServletException, IOException {

        

        // 設定回傳給前端的格式為 JSON

        response.setContentType("application/json;charset=UTF-8");

        PrintWriter out = response.getWriter();

        

        try {

            // 1. 接收前端 JS (fetch) 傳過來的明細資料

            int itemId = Integer.parseInt(request.getParameter("itemId"));

            int productId = Integer.parseInt(request.getParameter("productId"));

            int quantity = Integer.parseInt(request.getParameter("quantity"));

            int unitPrice = Integer.parseInt(request.getParameter("unitPrice"));



            // 2. 呼叫你原本就寫好的 OrderItemDAO 來更新這筆明細

            OrderItemDAO dao = new OrderItemDAO();

            boolean success = dao.updateItem(itemId, productId, quantity, unitPrice);



            // 3. 根據資料庫更新的結果，回傳 JSON 給前端

            if (success) {

                // 回傳成功，並且告訴前端更新了 1 筆

                out.print("{\"success\": true, \"updatedCount\": 1}");

            } else {

                out.print("{\"success\": false}");

            }

            

        } catch (Exception e) {

            e.printStackTrace();

            out.print("{\"success\": false, \"message\": \"系統發生錯誤\"}");

        }

    }

} 