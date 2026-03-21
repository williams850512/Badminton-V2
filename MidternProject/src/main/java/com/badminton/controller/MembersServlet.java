package com.badminton.controller;

import java.io.IOException;
import java.sql.Date;

import com.badminton.model.MembersBean;
import com.badminton.service.MembersService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/MembersServlet")
public class MembersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MembersService service = new MembersService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }  

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null) action = "showLogin";

        try {
            switch (action) {
                case "showLogin": request.getRequestDispatcher("/WEB-INF/views/members_login.jsp").forward(request, response); break;
                case "showRegister": request.getRequestDispatcher("/WEB-INF/views/members_register.jsp").forward(request, response); break;
                case "showProfile": request.getRequestDispatcher("/WEB-INF/views/members_profile.jsp").forward(request, response); break;
                case "login": processLogin(request, response); break;
                case "register": processRegister(request, response); break;
                case "logout": processLogout(request, response); break;
                case "update": processUpdate(request, response); break;
                default: response.sendRedirect("MembersServlet?action=showLogin"); break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("MembersServlet?action=showLogin");
        }
    }

    /**
     * 會員登入處理
     * Service 已調用 DAO 執行強制大小寫檢查
     */
    private void processLogin(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        MembersBean user = service.login(username, password);
        
        if (user != null) {
            request.getSession().setAttribute("user", user);
            response.sendRedirect("MembersServlet?action=showProfile");
        } else {
            // error=1 通常代表帳號密碼錯誤（包含大小寫不符）
            response.sendRedirect("MembersServlet?action=showLogin&error=1");
        }
    }

    /**
     * 會員註冊處理
     * Service 內部會先呼叫 isUsernameExists 檢查帳號是否重複
     */
    private void processRegister(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        
        MembersBean m = new MembersBean();
        m.setUsername(username);
        m.setPassword(request.getParameter("password"));
        m.setFullName(request.getParameter("fullName")); 
        m.setPhone(request.getParameter("phone"));
        m.setEmail(request.getParameter("email"));
        m.setGender(request.getParameter("gender"));
        
        String bday = request.getParameter("birthday");
        if (bday != null && !bday.isEmpty()) {
            try {
                m.setBirthday(Date.valueOf(bday));
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
            }
        }
        
        m.setMembershipLevel("Regular");
        m.setStatus("Active");
        m.setNote(""); 

        // 執行註冊
        if (service.register(m)) {
            // 成功註冊
            response.sendRedirect("MembersServlet?action=showLogin&status=ok");
        } else {
            // 失敗原因可能是：帳號重複 或 資料庫錯誤
            // 先檢查是否為帳號重複
            if (service.isUsernameExists(username)) {
                // error=2：提示帳號已存在（不論大小寫）
                response.sendRedirect("MembersServlet?action=showRegister&error=2");
            } else {
                // error=1：一般的註冊失敗提示
                response.sendRedirect("MembersServlet?action=showRegister&error=1");
            }
        }
    }

    /**
     * 修改個人資料處理
     */
    private void processUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        MembersBean currentUser = (MembersBean) session.getAttribute("user");
        
        if (currentUser == null) { 
            response.sendRedirect("MembersServlet?action=showLogin"); 
            return; 
        }

        MembersBean updateBean = new MembersBean();
        updateBean.setMemberId(currentUser.getMemberId());
        updateBean.setFullName(request.getParameter("fullName"));
        updateBean.setPhone(request.getParameter("phone"));
        updateBean.setEmail(request.getParameter("email"));
        updateBean.setGender(request.getParameter("gender"));
        
        String bday = request.getParameter("birthday");
        if (bday != null && !bday.isEmpty()) {
            try {
                updateBean.setBirthday(Date.valueOf(bday));
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
            }
        }
        
        // ✨ 重要：保留不可被會員修改的後台資料，避免更新後遺失
        updateBean.setMembershipLevel(currentUser.getMembershipLevel());
        updateBean.setStatus(currentUser.getStatus());
        updateBean.setNote(currentUser.getNote()); 

        if (service.updateProfile(updateBean)) {
            // 更新成功後，重新取得最新資料並同步 Session
            session.setAttribute("user", service.getMemberById(currentUser.getMemberId()));
            response.sendRedirect("MembersServlet?action=showProfile&msg=ok");
        } else {
            response.sendRedirect("MembersServlet?action=showProfile&msg=error");
        }
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("MembersServlet?action=showLogin");
    }
}