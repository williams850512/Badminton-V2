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
       
	// 1. 呼叫service
	private PickupGameSignupService signupService=new PickupGameSignupServiceImpl();
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    
	    // 2. 取得網頁傳來的「哪場球賽」的 ID (假設參數叫 gameId)
	    String gameIdStr = request.getParameter("gameId");
	    
	    // 3. 邏輯判斷：如果沒傳 ID，就給個預設值或報錯
	    if (gameIdStr != null && !gameIdStr.isEmpty()) {
	        Integer gameId = Integer.parseInt(gameIdStr);
	        
	        // 4. 【核心修改】：原本找 DAO，現在找 Service
            // 注意：isNewestFirst 設為 true，符合大師說的「最新、最先」
	        List<PickupGameSignupBean> list = signupService.getSignupListByGame(gameId, true);
	        
	        // 5. 存入 Request：這叫「取經回報」，把資料交給下一個環節
	        request.setAttribute("signupList", list);
	    }

	    // 6. 指路燈：導向您剛才截圖中建議的 WEB-INF 資料夾
	    request.getRequestDispatcher("/WEB-INF/views/signup_list.jsp").forward(request, response);
	}
}
