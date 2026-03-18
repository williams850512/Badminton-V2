package com.badminton.controller;

import java.io.IOException;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.badminton.model.MembersBean;
import com.badminton.service.MembersService;

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

        if (action == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            switch (action) {
                case "login": processLogin(request, response); break;
                case "register": processRegister(request, response); break;
                case "logout": processLogout(request, response); break;
                case "update": processUpdate(request, response); break;
                case "list": processList(request, response); break;
                case "edit": processEdit(request, response); break;
                case "delete": processDelete(request, response); break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp");
        }
    }

    // --- 登入 ---
    private void processLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        MembersBean user = service.login(request.getParameter("username"), request.getParameter("password"));
        if (user != null) {
            request.getSession().setAttribute("user", user);
            if ("admin".equals(user.getRole())) {
                response.sendRedirect("MembersServlet?action=list");
            } else {
                response.sendRedirect("profile.jsp");
            }
        } else {
            response.sendRedirect("login.jsp?error=1");
        }
    }

    // --- 註冊 (已加入性別與生日) ---
    private void processRegister(HttpServletRequest request, HttpServletResponse response) throws IOException {
        MembersBean m = new MembersBean();
        m.setUsername(request.getParameter("username"));
        m.setPassword(request.getParameter("password"));
        m.setName(request.getParameter("name"));
        m.setPhone(request.getParameter("phone"));
        m.setEmail(request.getParameter("email"));
        
        // 取得新欄位
        m.setGender(request.getParameter("gender"));
        String bday = request.getParameter("birthday");
        if (bday != null && !bday.isEmpty()) {
            m.setBirthday(Date.valueOf(bday)); // 轉為 java.sql.Date
        }
        
        if (service.register(m)) {
            response.sendRedirect("login.jsp?status=ok");
        } else {
            response.sendRedirect("register.jsp?error=1");
        }
    }

    // --- 修改資料 (已加入性別與生日) ---
    private void processUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        MembersBean currentUser = (MembersBean) session.getAttribute("user");
        if (currentUser == null) { response.sendRedirect("login.jsp"); return; }

        String idStr = request.getParameter("member_id");
        int targetId = (idStr != null && !idStr.isEmpty()) ? Integer.parseInt(idStr) : currentUser.getMemberId();

        MembersBean updateBean = new MembersBean();
        updateBean.setMemberId(targetId);
        updateBean.setName(request.getParameter("name"));
        updateBean.setPhone(request.getParameter("phone"));
        updateBean.setEmail(request.getParameter("email"));
        
        // 更新新欄位
        updateBean.setGender(request.getParameter("gender"));
        String bday = request.getParameter("birthday");
        if (bday != null && !bday.isEmpty()) {
            updateBean.setBirthday(Date.valueOf(bday));
        }
        
        if ("admin".equals(currentUser.getRole())) {
            updateBean.setRole(request.getParameter("role"));
        } else {
            updateBean.setRole(currentUser.getRole());
        }

        if (service.updateProfile(updateBean)) {
            if ("admin".equals(currentUser.getRole()) && idStr != null) {
                response.sendRedirect("MembersServlet?action=list&msg=update_ok");
            } else {
                // 更新後重新抓取資料放入 Session，確保畫面顯示最新資訊
                session.setAttribute("user", service.getMemberById(targetId));
                response.sendRedirect("profile.jsp?msg=ok");
            }
        }
    }

    // --- 管理員功能：列出、編輯、刪除 ---
    private void processList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("memberList", service.getAllMembers());
        request.getRequestDispatcher("listMembers.jsp").forward(request, response);
    }

    private void processEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            request.setAttribute("member", service.getMemberById(id));
            request.getRequestDispatcher("adminEditMembers.jsp").forward(request, response);
        } else {
            response.sendRedirect("MembersServlet?action=list");
        }
    }

    private void processDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        MembersBean admin = (MembersBean) session.getAttribute("user");

        if (admin != null && "admin".equals(admin.getRole())) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    service.deleteMember(Integer.parseInt(idStr));
                } catch (Exception e) { e.printStackTrace(); }
            }
            response.sendRedirect("MembersServlet?action=list&msg=del_ok");
        } else {
            response.sendRedirect("login.jsp?error=no_permission");
        }
    }

    // --- 登出 ---
    private void processLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.getSession().invalidate();
        response.sendRedirect("login.jsp");
    }
}