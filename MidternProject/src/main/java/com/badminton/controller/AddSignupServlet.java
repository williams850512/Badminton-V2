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

@WebServlet("/AddSignupServlet")
public class AddSignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PickupGameSignupService signupService = new PickupGameSignupServiceImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. 取得這場活動的 ID
        String gameIdStr = request.getParameter("gameId");

        // 2. 檢查登入狀態
        HttpSession session = request.getSession();
        Integer sessionMemberId = (Integer) session.getAttribute("memberId");

        Integer memberId = null; 

        // 判斷邏輯：如果 session 有 ID 就用它的，沒有就預設為 1 (薩拉)
        if (sessionMemberId != null) {
            memberId = sessionMemberId;
        } else {
            memberId = 1; 
        }

        // 3. 執行報名邏輯
        if (gameIdStr != null) {
            try {
                Integer gameId = Integer.parseInt(gameIdStr);
                System.out.println("準備報名：Game=" + gameId + ", Member=" + memberId);
                
                // 呼叫 Service 進行報名 (遠端連向組長資料庫)
                String resultMsg = signupService.registerString(gameId, memberId);
                request.setAttribute("msg", resultMsg);
            } catch (NumberFormatException e) {
                request.setAttribute("msg", "活動編號格式錯誤");
            }
        } else {
            request.setAttribute("msg", "找不到活動編號");
        }

        // 4. 引導至結果頁面
        request.getRequestDispatcher("/WEB-INF/views/signup_result.jsp").forward(request, response);
    }
} 