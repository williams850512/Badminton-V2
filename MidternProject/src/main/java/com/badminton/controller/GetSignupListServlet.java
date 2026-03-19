package com.badminton.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import com.badminton.model.PickupGameSignupBean;
import com.badminton.service.PickupGameSignupService;
import com.badminton.service.PickupGameSignupServiceImpl;

@WebServlet("/GetSignupListServlet")
public class GetSignupListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PickupGameSignupService signupService = new PickupGameSignupServiceImpl();

    // 支援 POST 請求，防止跳轉時發生 405 業障
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    
        String gameIdStr = request.getParameter("gameId");
        Integer gameId = null;

        // 1. 判定要顯示哪一場比賽的名單
        if (gameIdStr != null && !gameIdStr.isEmpty()) {
            // 如果網址有帶 gameId (例如 ?gameId=5)
            gameId = Integer.parseInt(gameIdStr);
        } else {
            // 如果沒傳 ID (例如剛發起完)，自動抓最新的一場活動
            gameId = signupService.getLatestGameId(); 
        }

        // 2. 如果有找到比賽 ID，就去撈報名清單
        if (gameId != null) {
            List<PickupGameSignupBean> list = signupService.getSignupListByGame(gameId, true);
            // 將名單存入 Request 供 JSP 讀取
            request.setAttribute("signupList", list);
            request.setAttribute("currentGameId", gameId);
        } else {
            request.setAttribute("msg", "目前系統中尚無任何球賽活動。");
        }

        // 3. 指向 JSP 頁面
        request.getRequestDispatcher("/WEB-INF/views/signup_list.jsp").forward(request, response);
    }
}