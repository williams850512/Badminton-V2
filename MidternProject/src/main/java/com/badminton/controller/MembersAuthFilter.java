package com.badminton.controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import com.badminton.model.MembersBean;

@WebFilter("/MembersServlet")
public class MembersAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String action = req.getParameter("action");
        
        HttpSession session = req.getSession(false);
        // 檢查一般會員 Session 標記 "user"
        MembersBean user = (session != null) ? (MembersBean) session.getAttribute("user") : null;

        // 【攔截邏輯】
        // 如果動作是「顯示個人資料」或「更新資料」，但沒登入，就踢回登入頁
        if ("showProfile".equals(action) || "update".equals(action)) {
            if (user == null) {
                res.sendRedirect(req.getContextPath() + "/MembersServlet?action=showLogin&error=need_login");
                return;
            }
        }

        // 通過驗證，繼續執行 MembersServlet
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}