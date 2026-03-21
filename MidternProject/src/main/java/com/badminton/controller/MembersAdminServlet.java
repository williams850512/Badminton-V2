package com.badminton.controller;

import java.io.IOException;
import java.util.List;
import java.sql.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.badminton.model.MembersAdminBean;
import com.badminton.model.MembersBean;
import com.badminton.service.MembersAdminService;
import com.badminton.service.MembersService;

@WebServlet("/MembersAdminServlet")
public class MembersAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private MembersAdminService adminService = new MembersAdminService();
    private MembersService memberService = new MembersService(); 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            action = "showLogin";
        }

        switch (action) {
            case "showLogin":
                request.getRequestDispatcher("/WEB-INF/views/members_adminLogin.jsp").forward(request, response);
                break;
            case "dashboard":
                processDashboard(request, response);
                break;
            case "search":
                processSearch(request, response);
                break;
            case "showAdd": 
                request.getRequestDispatcher("/WEB-INF/views/members_adminAdd.jsp").forward(request, response);
                break;
            case "showEdit":
                processShowEdit(request, response);
                break;
            case "delete":
                processDelete(request, response);
                break;
            case "listAdmins": 
                processListAdmins(request, response);
                break;
            case "showAdminAdd": 
                request.getRequestDispatcher("/WEB-INF/views/members_adminsSelfAdd.jsp").forward(request, response);
                break;
            case "showAdminEdit":
                processShowAdminEdit(request, response);
                break;
            case "logout":
                processLogout(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=showLogin");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            processLogin(request, response);
        } else if ("add".equals(action)) { 
            processAdd(request, response);
        } else if ("update".equals(action)) {
            processUpdate(request, response);
        } else if ("adminUpdate".equals(action)) { 
            processAdminUpdate(request, response);
        } else if ("adminAdd".equals(action)) { 
            processAdminAdd(request, response);
        } else {
            doGet(request, response);
        }
    }

    // --- 管理員登入邏輯 (含狀態檢查) ---
    private void processLogin(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        MembersAdminBean admin = adminService.login(user, pass);

        if (admin != null) {
            // 🔴 檢查帳號是否被停用
            if ("inactive".equalsIgnoreCase(admin.getStatus())) {
                request.setAttribute("error", "您的帳號已被停用，請聯繫系統管理員。");
                request.getRequestDispatcher("/WEB-INF/views/members_adminLogin.jsp").forward(request, response);
                return;
            }
            
            HttpSession session = request.getSession();
            session.setAttribute("adminUser", admin);
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard");
        } else {
            // 帳密錯誤，導回登入頁並帶錯誤參數
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=showLogin&error=1");
        }
    }

    // --- 管理員管理邏輯 ---
    private void processListAdmins(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<MembersAdminBean> adminList = adminService.getAllAdmins(); 
        request.setAttribute("adminList", adminList);
        request.getRequestDispatcher("/WEB-INF/views/members_adminList.jsp").forward(request, response);
    }

    private void processShowAdminEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            MembersAdminBean admin = adminService.getAdminById(id);
            request.setAttribute("a", admin);
            request.getRequestDispatcher("/WEB-INF/views/members_adminsSelfEdit.jsp").forward(request, response);
        }
    }

    private void processAdminAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            MembersAdminBean a = new MembersAdminBean();
            a.setUsername(request.getParameter("username"));
            a.setPassword(request.getParameter("password"));
            a.setFullName(request.getParameter("fullName"));
            a.setGender(request.getParameter("gender")); // 新增性別
            a.setRole(request.getParameter("role"));
            a.setPhone(request.getParameter("phone"));
            a.setEmail(request.getParameter("email")); // 新增信箱
            a.setStatus("active"); // 新增時預設啟用

            String bday = request.getParameter("birthday"); // 新增生日
            if (bday != null && !bday.isEmpty()) a.setBirthday(Date.valueOf(bday));

            if (adminService.addAdmin(a)) {
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=add_ok");
            } else {
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=showAdminAdd&error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=error");
        }
    }

    private void processAdminUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("adminId"));
            MembersAdminBean a = new MembersAdminBean();
            a.setAdminId(id);
            a.setFullName(request.getParameter("fullName"));
            a.setGender(request.getParameter("gender")); // 更新性別
            a.setRole(request.getParameter("role"));
            a.setStatus(request.getParameter("status")); // 更新狀態
            a.setPhone(request.getParameter("phone"));
            a.setEmail(request.getParameter("email")); // 更新信箱
            
            String bday = request.getParameter("birthday"); // 更新生日
            if (bday != null && !bday.isEmpty()) a.setBirthday(Date.valueOf(bday));

            if (adminService.updateAdmin(a)) {
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=update_ok");
            } else {
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=error");
        }
    }

    // --- 會員管理邏輯 (Dashboard / CRUD) ---
    private void processDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<MembersBean> memberList = memberService.getAllMembers();
        request.setAttribute("memberList", memberList);
        request.getRequestDispatcher("/WEB-INF/views/members_list.jsp").forward(request, response);
    }

    private void processSearch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<MembersBean> memberList = (keyword != null && !keyword.trim().isEmpty()) 
                                        ? memberService.searchMembers(keyword) : memberService.getAllMembers();
        request.setAttribute("memberList", memberList);
        request.getRequestDispatcher("/WEB-INF/views/members_list.jsp").forward(request, response);
    }

    private void processAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            MembersBean m = new MembersBean();
            m.setUsername(request.getParameter("username"));
            m.setPassword(request.getParameter("password"));
            m.setFullName(request.getParameter("fullName"));
            m.setGender(request.getParameter("gender"));
            String bday = request.getParameter("birthday");
            if (bday != null && !bday.isEmpty()) m.setBirthday(Date.valueOf(bday));
            m.setPhone(request.getParameter("phone"));
            m.setEmail(request.getParameter("email"));
            m.setMembershipLevel(request.getParameter("membershipLevel"));
            m.setStatus("Active");

            if (memberService.register(m)) {
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=add_ok");
            } else {
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=showAdd&error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=error");
        }
    }

    private void processShowEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("memberId");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            MembersBean member = memberService.getMemberById(id);
            request.setAttribute("m", member);
            request.getRequestDispatcher("/WEB-INF/views/members_adminEdit.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard");
        }
    }

    private void processUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("memberId"));
            MembersBean member = new MembersBean();
            member.setMemberId(id);
            member.setFullName(request.getParameter("fullName"));
            member.setMembershipLevel(request.getParameter("membershipLevel"));
            member.setStatus(request.getParameter("status"));
            member.setGender(request.getParameter("gender"));
            String bday = request.getParameter("birthday");
            if (bday != null && !bday.isEmpty()) member.setBirthday(Date.valueOf(bday));
            member.setPhone(request.getParameter("phone"));
            member.setEmail(request.getParameter("email"));

            memberService.updateMember(member);
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=update_ok");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=error");
        }
    }

    private void processDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("memberId");
        if (idStr != null) {
            memberService.deleteMember(Integer.parseInt(idStr));
        }
        response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=del_ok");
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
        response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=showLogin");
    }
}