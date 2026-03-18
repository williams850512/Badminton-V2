package com.badminton.controller;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.badminton.model.MembersBean;

/**
 * 會員權限過濾器
 * 負責攔截非法進入管理後台的請求
 */
@WebFilter(urlPatterns = {"/listMembers.jsp", "/adminEditMembers.jsp"})
public class MembersAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        
        // 取得當前 Session，若無則不建立新 Session
        HttpSession session = req.getSession(false);
        
        // 從 Session 中取出登入時存入的 user 物件
        MembersBean user = (session != null) ? (MembersBean) session.getAttribute("user") : null;

        // 權限檢查邏輯：
        // 1. 未登入 (user == null)
        // 2. 身分不是管理員 (!"admin".equals(user.getRole()))
        if (user == null || !"admin".equals(user.getRole())) {
            // 重新導向至登入頁面，並附加錯誤代碼
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=no_permission");
        } else {
            // 通過驗證，讓請求繼續往下走（前往目標 JSP）
            chain.doFilter(request, response);
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 濾鏡初始化邏輯（若無特殊需求可留空）
    }

    @Override
    public void destroy() {
        // 濾鏡銷毀時的清理工作
    }
}