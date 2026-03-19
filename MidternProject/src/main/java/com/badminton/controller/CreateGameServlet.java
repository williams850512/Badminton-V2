package com.badminton.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.badminton.service.PickupGameSignupService;
import com.badminton.service.PickupGameSignupServiceImpl;

@WebServlet("/CreateGameServlet")
public class CreateGameServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PickupGameSignupService gameService = new PickupGameSignupServiceImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // 1. 取得主揪身分 (薩拉 ID:4)
        Integer hostId = (Integer) session.getAttribute("memberId");
        if (hostId == null) {
            hostId = 4; // 預設為薩拉，正式環境應由 Session 取得
        }

        try {
            // 2. 接收參數 (對應 JSP 的 name 屬性)
            int courtId = Integer.parseInt(request.getParameter("courtId"));
            String gameDate = request.getParameter("gameDate");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime"); 
            int neededPlayers = Integer.parseInt(request.getParameter("neededPlayers"));
            int totalMaxPlayers = neededPlayers + 1; // 總人數 = 徵求人數 + 1(主揪)

            // 3. 執行發起 + 自動報名 (Service 內部應已處理好 insert)
            boolean success = gameService.createAndJoin(hostId, courtId, gameDate, startTime, endTime, totalMaxPlayers);

            if (success) {
                // 【關鍵重定向】：去找剛才創立的那場 ID
                Integer latestGameId = gameService.getLatestGameId();
                
                // 重定向到名單 Servlet，並帶上 ID。這會讓網址列變成真正的 ID
                response.sendRedirect(request.getContextPath() + "/GetSignupListServlet?gameId=" + latestGameId);
                return; 
            } else {
                request.setAttribute("msg", "發起失敗，該時段已有活動。");
                request.getRequestDispatcher("/WEB-INF/views/create_game.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "格式錯誤：" + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/create_game.jsp").forward(request, response);
        }
    }
}