package com.badminton.controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import com.badminton.model.MembersAdminBean;

@WebFilter(urlPatterns = {"/MembersAdminServlet", "/views/members_list.jsp", "/views/members_adminEdit.jsp"})
public class MembersAdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        String action = req.getParameter("action");
        // 確保 Key 名稱與 Servlet 存入時完全一致
        MembersAdminBean admin = (session != null) ? (MembersAdminBean) session.getAttribute("adminUser") : null;

        // 判定是否為登入相關動作 (action 為空或等於登入指令)
        boolean isLoginRequest = (action == null || action.isEmpty()) 
                                || "showLogin".equals(action) 
                                || "login".equals(action);
        
        // 【核心邏輯】有管理員物件 OR 正在登入頁面 -> 放行
        if (admin != null || isLoginRequest) {
            chain.doFilter(request, response);
        } else {
            // 如果被踢掉，Console 會印出原因，方便抓蟲
            System.out.println("--- 安全攔截 --- 動作: " + action + " | Session狀態: " + (session != null ? "有效" : "無效"));
            res.sendRedirect(req.getContextPath() + "/MembersServlet?action=showLogin");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    @Override
    public void destroy() {}
}