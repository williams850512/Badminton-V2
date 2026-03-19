package com.badminton.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // 補上這個：感應 Session
import java.io.IOException;

import com.badminton.service.PickupGameSignupService; // 引用您剛剛修好的 Service 介面
import com.badminton.service.PickupGameSignupServiceImpl; // 引用實作類別

@WebServlet("/CreateGameServlet")
public class CreateGameServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // 使用您剛才重整好的 Service (包含 register, list, createAndJoin 三大功能)
    private PickupGameSignupService gameService = new PickupGameSignupServiceImpl(); 

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // 1. 取得主揪身分 (模擬王小明 ID:2)
        // 這裡就是您之後要接同學「登入模組」的地方
        Integer hostId = (Integer) session.getAttribute("memberId");
        if (hostId == null) {
            hostId = 2; 
        }

        try {
            // 2. 接收前端表單資料
            // 這些參數要跟您的 create_game.jsp 裡的 name 屬性對應
            int courtId = Integer.parseInt(request.getParameter("courtId"));
            String gameDate = request.getParameter("gameDate");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime"); 
            int maxPlayers = Integer.parseInt(request.getParameter("maxPlayers")); 

            // 3. 呼叫 Service 執行「發起活動 + 自動幫主揪報名」
            // 這是您要的「主揪感」：一鍵完成兩件事
            boolean success = gameService.createAndJoin(hostId, courtId, gameDate, startTime, endTime, maxPlayers);

            if (success) {
                request.setAttribute("msg", "揪團發起成功！您已自動成為第 1 位成員。");
            } else {
                request.setAttribute("msg", "發起失敗，該時段可能已有活動或資料庫連線中斷。");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "資料格式錯誤，請檢查輸入內容。");
        }

        // 4. 引導至名單頁面，讓主揪立刻看到自己出現在表格第一列
        // 這裡跳轉到 GetSignupListServlet 會重新查詢資料庫，確保資料是真的有進去
        request.getRequestDispatcher("/GetSignupListServlet").forward(request, response);
    }
}
