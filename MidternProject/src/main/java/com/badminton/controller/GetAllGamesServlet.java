package com.badminton.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import com.badminton.service.PickupGameSignupService;
import com.badminton.service.PickupGameSignupServiceImpl;
import com.badminton.model.PickupGameBean; // 請確認您的 Bean 名稱是否正確

@WebServlet("/GetAllGamesServlet")
public class GetAllGamesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PickupGameSignupService gameService = new PickupGameSignupServiceImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("--- 進入：找球賽清單 ---");

        try {
            // 1. 向 Service 請求所有開放中的場次
            // 您可能需要在 Service 介面補上 getAllOpenGames 方法
            List<PickupGameBean> allGames = gameService.getAllOpenGames();
            
            // 2. 存入 Request，讓 JSP 可以用 ${allGames} 讀取
            request.setAttribute("allGames", allGames);
            
            // 3. 指向「加入臨打」的列表頁面
            request.getRequestDispatcher("/WEB-INF/views/game_list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "讀取場次列表失敗：" + e.getMessage());
        }
    }
}