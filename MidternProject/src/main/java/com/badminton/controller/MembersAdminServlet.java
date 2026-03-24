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

        MembersAdminBean currentLogin = (MembersAdminBean) request.getSession().getAttribute("adminUser");

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
                if (currentLogin != null && "manager".equals(currentLogin.getRole())) {
                    processListAdmins(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=no_permission");
                }
                break;
            case "showAdminAdd": 
                if (currentLogin != null && "manager".equals(currentLogin.getRole())) {
                    request.getRequestDispatcher("/WEB-INF/views/members_adminsSelfAdd.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=no_permission");
                }
                break;
            case "showAdminEdit":
                processShowAdminEdit(request, response);
                break;
            case "searchAdmin":
                if (currentLogin != null && "manager".equals(currentLogin.getRole())) {
                    String keyword = request.getParameter("keyword");
                    java.util.List<MembersAdminBean> adminList;
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        adminList = adminService.searchAdmins(keyword.trim());
                    } else {
                        adminList = adminService.getAllAdmins();
                    }
                    request.setAttribute("adminList", adminList);
                    request.getRequestDispatcher("/WEB-INF/views/members_adminList.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=no_permission");
                }
                break;
            case "deleteAdmin": 
                processAdminDelete(request, response);
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
        } else if ("updateMemberNote".equals(action)) {
            processUpdateMemberNote(request, response);
        } else if ("updateAdminNote".equals(action)) {
            processUpdateAdminNote(request, response);
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

    private void processAdminDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        MembersAdminBean currentLogin = (MembersAdminBean) request.getSession().getAttribute("adminUser");
        try {
            String idStr = request.getParameter("id");
            if (idStr != null && currentLogin != null && "manager".equals(currentLogin.getRole())) {
                int targetId = Integer.parseInt(idStr);
                if (targetId != currentLogin.getAdminId()) {
                    adminService.deleteAdmin(targetId);
                    response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=del_ok");
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=error");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=error");
        }
    }

    private void processShowAdminEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        MembersAdminBean currentLogin = (MembersAdminBean) request.getSession().getAttribute("adminUser");
        String idStr = request.getParameter("id");
        
        if (idStr != null && currentLogin != null) {
            int targetId = Integer.parseInt(idStr);
            if (!"manager".equals(currentLogin.getRole()) && currentLogin.getAdminId() != targetId) {
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=no_permission");
                return;
            }

            MembersAdminBean admin = adminService.getAdminById(targetId);
            request.setAttribute("a", admin);
            request.getRequestDispatcher("/WEB-INF/views/members_adminsSelfEdit.jsp").forward(request, response);
        }
    }

    private void processAdminUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        MembersAdminBean currentLogin = (MembersAdminBean) request.getSession().getAttribute("adminUser");
        try {
            String idStr = request.getParameter("adminId");
            if (idStr != null && currentLogin != null) {
                int targetId = Integer.parseInt(idStr);

                if (!"manager".equals(currentLogin.getRole()) && currentLogin.getAdminId() != targetId) {
                    response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard");
                    return;
                }

                MembersAdminBean a = adminService.getAdminById(targetId);
                if (a != null) {
                    a.setFullName(request.getParameter("fullName"));
                    a.setPhone(request.getParameter("phone"));
                    a.setEmail(request.getParameter("email"));
                    a.setGender(request.getParameter("gender"));
                    
                    String bday = request.getParameter("birthday");
                    if (bday != null && !bday.trim().isEmpty()) {
                        a.setBirthday(Date.valueOf(bday.trim()));
                    }

                    // ✨ 權限防禦：只有「主管」可以改 Role 與 Status
                    // 如果是一般職員，即便前端送來新值，後端也強制維持原狀
                    if ("manager".equals(currentLogin.getRole())) {
                        a.setRole(request.getParameter("role"));
                        a.setStatus(request.getParameter("status"));
                    }

                    String newPwd = request.getParameter("newPassword");
                    if (newPwd != null && !newPwd.trim().isEmpty()) {
                        a.setPassword(newPwd); 
                    }

                    adminService.updateAdmin(a);
                    
                    if (currentLogin.getAdminId() == targetId) {
                        request.getSession().setAttribute("adminUser", a);
                    }

                    // 修改：儲存更新後若為主觀則返回 listAdmins 畫面，否則返回 dashboard
                    if ("manager".equals(currentLogin.getRole())) {
                        response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=update_ok");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=update_ok");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=error");
        }
    }

    private void processAdminAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        MembersAdminBean currentLogin = (MembersAdminBean) request.getSession().getAttribute("adminUser");
        if (currentLogin == null || !"manager".equals(currentLogin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard");
            return;
        }

        try {
            MembersAdminBean a = new MembersAdminBean();
            a.setUsername(request.getParameter("username"));
            a.setPassword(request.getParameter("password"));
            a.setFullName(request.getParameter("fullName"));
            a.setGender(request.getParameter("gender"));
            
            String bday = request.getParameter("birthday");
            if (bday != null && !bday.trim().isEmpty()) {
                a.setBirthday(Date.valueOf(bday.trim()));
            }

            a.setRole(request.getParameter("role"));
            a.setPhone(request.getParameter("phone"));
            a.setEmail(request.getParameter("email"));
            a.setNote(request.getParameter("note"));
            a.setStatus("active");

            if (adminService.addAdmin(a)) {
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=add_ok");
            } else {
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=showAdminAdd&error=duplicate");
            }
        } catch (Exception e) {
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

    private void processAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            MembersBean m = new MembersBean();
            m.setUsername(request.getParameter("username"));
            m.setPassword(request.getParameter("password"));
            m.setFullName(request.getParameter("fullName"));
            m.setGender(request.getParameter("gender"));
            
            String bday = request.getParameter("birthday");
            if (bday != null && !bday.trim().isEmpty()) {
                m.setBirthday(Date.valueOf(bday.trim()));
            }
            
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
        MembersAdminBean currentLogin = (MembersAdminBean) request.getSession().getAttribute("adminUser");
        try {
            int id = Integer.parseInt(request.getParameter("memberId"));
            MembersBean member = memberService.getMemberById(id);
            if (member != null && currentLogin != null) {
                // 基本資料大家都能改
                member.setFullName(request.getParameter("fullName"));
                member.setGender(request.getParameter("gender"));
                
                String bday = request.getParameter("birthday");
                if (bday != null && !bday.trim().isEmpty()) {
                    member.setBirthday(Date.valueOf(bday.trim()));
                }
                
                member.setPhone(request.getParameter("phone"));
                member.setEmail(request.getParameter("email"));

                // ✨ 權限防禦：修改一般會員時，只有主管能改 Level 與 Status
                if ("manager".equals(currentLogin.getRole())) {
                    member.setMembershipLevel(request.getParameter("membershipLevel"));
                    member.setStatus(request.getParameter("status"));
                } else {
                    // 一般職員的話，這兩項維持不動 (不從 parameter 抓取)
                    System.out.println("偵測到非主管企圖修改會員狀態，已略過該欄位更新。");
                }

                memberService.updateMember(member);
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=update_ok");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=error");
        }
    }

    private void processDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        MembersAdminBean currentLogin = (MembersAdminBean) request.getSession().getAttribute("adminUser");
        if (currentLogin != null && "manager".equals(currentLogin.getRole())) {
            try {
                String idStr = request.getParameter("memberId");
                if (idStr != null) memberService.deleteMember(Integer.parseInt(idStr));
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=del_ok");
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=error");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=no_permission");
        }
    }

    private void processLogin(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        MembersAdminBean admin = adminService.login(user, pass);

        if (admin != null) {
            if ("inactive".equalsIgnoreCase(admin.getStatus())) {
                request.setAttribute("error", "您的帳號已被停用，請聯繫系統主管。");
                request.getRequestDispatcher("/WEB-INF/views/members_adminLogin.jsp").forward(request, response);
                return;
            }
            request.getSession().setAttribute("adminUser", admin);
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=showLogin&error=1");
        }
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
        response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=showLogin");
    }

    private void processUpdateMemberNote(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int memberId = Integer.parseInt(request.getParameter("memberId"));
            String note = request.getParameter("note");
            memberService.updateNote(memberId, note);
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=update_ok");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=dashboard&msg=error");
        }
    }

    private void processUpdateAdminNote(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int adminId = Integer.parseInt(request.getParameter("id"));
            String note = request.getParameter("note");
            adminService.updateAdminNote(adminId, note);
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=update_ok");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/MembersAdminServlet?action=listAdmins&msg=error");
        }
    }
}