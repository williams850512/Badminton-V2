package com.badminton.controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import com.badminton.model.MembersAdminBean;

/**
 * 系統管理員權限過濾器
 * 1. 攔截未登入使用者
 * 2. 限制一般職員 (Staff) 存取主管 (Manager) 功能
 */
@WebFilter(urlPatterns = {
    "/MembersAdminServlet", 
    "/views/members_list.jsp", 
    "/views/members_adminEdit.jsp",
    "/views/members_adminList.jsp",
    "/views/members_adminAdd.jsp"
})
public class MembersAdminAuthFilter implements Filter {

    // 🛡️ 定義只有「主管 (manager)」才能執行的動作清單
    private static final List<String> MANAGER_ONLY_ACTIONS = Arrays.asList(
        "listAdmins",    // 查看管理員列表
        "showAdminAdd",  // 顯示新增管理員頁面
        "adminAdd",      // 執行新增管理員
        "deleteAdmin",   // 刪除管理員
        "searchAdmin"    // 搜尋管理員
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        String action = req.getParameter("action");
        String uri = req.getRequestURI();
        
        // 取得登入的管理員物件
        MembersAdminBean admin = (session != null) ? (MembersAdminBean) session.getAttribute("adminUser") : null;

        // 1. ✨ 判定是否為登入/登出相關動作 (白名單，不攔截)
        // 修正重點：確保 "login" 與 "adminLogin" 都被允許通過
        boolean isLoginRequest = (action == null || action.isEmpty()) 
                                || "showLogin".equals(action) 
                                || "login".equals(action) 
                                || "adminLogin".equals(action)
                                || "logout".equals(action);
        
        // 2. 如果根本沒登入，且不是要去登入相關功能 -> 強制導向登入頁
        if (admin == null && !isLoginRequest) {
            System.out.println("--- [未登入攔截] --- 試圖存取: " + uri + " | Action: " + action);
            res.sendRedirect(req.getContextPath() + "/MembersAdminServlet?action=showLogin");
            return;
        }

        // 3. ✨ 核心權限檢查：已登入狀態下的行為控制
        if (admin != null) {
            String userRole = admin.getRole(); // manager 或 staff
            
            // A. 檢查 Action 權限 (防止 Staff 執行 Manager 專屬動作)
            if (action != null && MANAGER_ONLY_ACTIONS.contains(action) && !"manager".equals(userRole)) {
                System.out.println("--- [權限不足攔截] --- 使用者: " + admin.getUsername() + " 試圖執行主管動作: " + action);
                res.sendRedirect(req.getContextPath() + "/MembersAdminServlet?action=dashboard");
                return;
            }
            
            // B. 檢查直接存取 JSP 的權限 (防止 Staff 手動輸入 URL 進入敏感頁面)
            if ((uri.contains("members_adminList.jsp") || uri.contains("members_adminAdd.jsp")) 
                && !"manager".equals(userRole)) {
                System.out.println("--- [頁面存取攔截] --- 職員不可存取管理員列表頁面");
                res.sendRedirect(req.getContextPath() + "/MembersAdminServlet?action=dashboard");
                return;
            }
        }

        // 通過所有檢查，放行
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void destroy() {}
}