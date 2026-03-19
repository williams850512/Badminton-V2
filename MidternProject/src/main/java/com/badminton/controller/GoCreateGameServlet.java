package com.badminton.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 功能：開啟「發起揪團」的表單頁面
 * 路由：/GoCreateGame
 */
@WebServlet("/GoCreateGame")
public class GoCreateGameServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 可以在這裡先準備資料，例如：從資料庫撈出球館清單
        // request.setAttribute("venues", venueService.getAll());
        
        System.out.println("--- 進入發起揪團表單 ---");
        
        // 指向藏在 WEB-INF 裡的 JSP 寶藏
        request.getRequestDispatcher("/WEB-INF/views/create_game.jsp").forward(request, response);
    }
}