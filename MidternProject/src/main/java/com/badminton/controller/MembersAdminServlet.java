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
        if (action == null || action.isEmpty()) action = "showLogin";

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
            case "searchAdmin": 
                processAdminSearch(request, response);
                break;
            case "deleteAdmin": 
                processAdminDelete(request, response);
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
        } else if ("updateNote".equals(action)) { 
            processUpdateNote(request, response); 
        } else if ("updateAdminNote".equals(action)) { 
            processUpdateAdminNote(request, response); 
        } else if ("adminUpdate".equals(action)) { 
            processAdminUpdate(request, response);
        } else if ("adminAdd".equals(action)) { 
            processAdminAdd(request, response);
        } else {
            doGet(request, response);
        }
    }

    // --- 管理員管理邏輯 ---

    private void processListAdmins(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<MembersAdminBean> adminList = adminService.getAllAdmins(); 
        request.setAttribute("adminList", adminList);
        request.getRequestDispatcher("/WEB-INF/views/members_adminList.jsp").forward(request, response);
    }

    private void processUpdateAdminNote(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String idStr = request.getParameter("id");
            String note = request.getParameter("note");
            
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                boolean success = adminService.updateAdminNote(id, note); 
                
                String status = success ? "note_ok" : "update_fail";
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=" + status);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=error");
        }
    }

    private void processAdminSearch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<MembersAdminBean> adminList = (keyword != null && !keyword.trim().isEmpty()) 
                                        ? adminService.searchAdmins(keyword) : adminService.getAllAdmins();
        request.setAttribute("adminList", adminList);
        request.getRequestDispatcher("/WEB-INF/views/members_adminList.jsp").forward(request, response);
    }

    private void processAdminDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                adminService.deleteAdmin(Integer.parseInt(idStr));
            }
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=del_ok");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=error");
        }
    }

    private void processShowAdminEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            MembersAdminBean admin = adminService.getAdminById(Integer.parseInt(idStr));
            request.setAttribute("a", admin);
            request.getRequestDispatcher("/WEB-INF/views/members_adminsSelfEdit.jsp").forward(request, response);
        }
    }

    /**
     * ✨ 管理員新增另一個管理員
     * 🛡️ 加入帳號重複判斷邏輯
     */
    private void processAdminAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        try {
            MembersAdminBean a = new MembersAdminBean();
            a.setUsername(username);
            a.setPassword(request.getParameter("password"));
            a.setFullName(request.getParameter("fullName"));
            a.setGender(request.getParameter("gender"));
            a.setRole(request.getParameter("role"));
            a.setPhone(request.getParameter("phone"));
            a.setEmail(request.getParameter("email"));
            a.setNote(request.getParameter("note"));
            
            String bday = request.getParameter("birthday");
            if (bday != null && !bday.isEmpty()) a.setBirthday(Date.valueOf(bday));

            if (adminService.addAdmin(a)) {
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=add_ok");
            } else {
                // 失敗判斷：檢查是否因為帳號重複
                if (adminService.isAdminExists(username)) {
                    response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=showAdminAdd&error=2");
                } else {
                    response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=showAdminAdd&error=1");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=error");
        }
    }

    private void processAdminUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String idStr = request.getParameter("adminId");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                MembersAdminBean a = adminService.getAdminById(id);
                if (a != null) {
                    a.setFullName(request.getParameter("fullName"));
                    a.setGender(request.getParameter("gender"));
                    a.setRole(request.getParameter("role"));
                    a.setStatus(request.getParameter("status"));
                    a.setPhone(request.getParameter("phone"));
                    a.setEmail(request.getParameter("email"));
                    a.setNote(request.getParameter("note"));
                    String bday = request.getParameter("birthday");
                    if (bday != null && !bday.isEmpty()) a.setBirthday(Date.valueOf(bday));

                    adminService.updateAdmin(a);
                    response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=update_ok");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=error");
        }
    }

    // --- 會員管理邏輯 ---

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

    /**
     * ✨ 管理員新增會員
     * 🛡️ 加入帳號重複判斷邏輯
     */
    private void processAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        try {
            MembersBean m = new MembersBean();
            m.setUsername(username);
            m.setPassword(request.getParameter("password"));
            m.setFullName(request.getParameter("fullName"));
            m.setGender(request.getParameter("gender"));
            String bday = request.getParameter("birthday");
            if (bday != null && !bday.isEmpty()) m.setBirthday(Date.valueOf(bday));
            m.setPhone(request.getParameter("phone"));
            m.setEmail(request.getParameter("email"));
            m.setMembershipLevel(request.getParameter("membershipLevel"));
            m.setStatus("Active");
            m.setNote(request.getParameter("note"));

            if (memberService.register(m)) {
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=add_ok");
            } else {
                // 失敗判斷：檢查是否因為帳號重複
                if (memberService.isUsernameExists(username)) {
                    response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=showAdd&error=2");
                } else {
                    response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=showAdd&error=1");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=error");
        }
    }

    private void processShowEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("memberId");
        if (idStr != null) {
            MembersBean member = memberService.getMemberById(Integer.parseInt(idStr));
            request.setAttribute("m", member);
            request.getRequestDispatcher("/WEB-INF/views/members_adminEdit.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard");
        }
    }

    private void processUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("memberId"));
            MembersBean member = memberService.getMemberById(id);
            if (member != null) {
                member.setFullName(request.getParameter("fullName"));
                member.setMembershipLevel(request.getParameter("membershipLevel"));
                member.setStatus(request.getParameter("status"));
                member.setGender(request.getParameter("gender"));
                String bday = request.getParameter("birthday");
                if (bday != null && !bday.isEmpty()) member.setBirthday(Date.valueOf(bday));
                member.setPhone(request.getParameter("phone"));
                member.setEmail(request.getParameter("email"));
                member.setNote(request.getParameter("note"));

                memberService.updateMember(member);
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=update_ok");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=error");
        }
    }

    private void processUpdateNote(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String idStr = request.getParameter("memberId");
            String note = request.getParameter("note");
            
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                boolean success = memberService.updateNote(id, note);
                
                String status = success ? "note_ok" : "update_fail";
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=" + status);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=error");
        }
    }

    private void processDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String idStr = request.getParameter("memberId");
            if (idStr != null) memberService.deleteMember(Integer.parseInt(idStr));
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=del_ok");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=error");
        }
    }

    /**
     * 管理員登入邏輯
     */
    private void processLogin(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        MembersAdminBean admin = adminService.login(user, pass);

        if (admin != null) {
            if ("inactive".equalsIgnoreCase(admin.getStatus())) {
                request.setAttribute("error", "您的帳號已被停用，請聯繫系統管理員。");
                request.getRequestDispatcher("/WEB-INF/views/members_adminLogin.jsp").forward(request, response);
                return;
            }
            request.getSession().setAttribute("adminUser", admin);
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard");
        } else {
            // 登入失敗（帳密錯或大小寫不對），帶 error=1
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=showLogin&error=1");
        }
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
        response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=showLogin");
    }
}