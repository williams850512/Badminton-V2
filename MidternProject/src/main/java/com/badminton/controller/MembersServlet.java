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

    private void processLogin(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        MembersBean user = service.login(request.getParameter("username"), request.getParameter("password"));
        if (user != null) {
            request.getSession().setAttribute("user", user);
            response.sendRedirect("MembersServlet?action=showProfile");
        } else {
            response.sendRedirect("MembersServlet?action=showLogin&error=1");
        }
    }

    private void processRegister(HttpServletRequest request, HttpServletResponse response) throws IOException {
        MembersBean m = new MembersBean();
        m.setUsername(request.getParameter("username"));
        m.setPassword(request.getParameter("password"));
        m.setFullName(request.getParameter("fullName")); // 對齊 JSP 的 name="fullName"
        m.setPhone(request.getParameter("phone"));
        m.setEmail(request.getParameter("email"));
        m.setGender(request.getParameter("gender"));
        String bday = request.getParameter("birthday");
        if (bday != null && !bday.isEmpty()) m.setBirthday(Date.valueOf(bday));
        m.setMembershipLevel("Normal");
        m.setStatus("Active");
        if (service.register(m)) response.sendRedirect("MembersServlet?action=showLogin&status=ok");
        else response.sendRedirect("MembersServlet?action=showRegister&error=1");
    }

    private void processUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        MembersBean currentUser = (MembersBean) session.getAttribute("user");
        if (currentUser == null) { response.sendRedirect("MembersServlet?action=showLogin"); return; }
        MembersBean updateBean = new MembersBean();
        updateBean.setMemberId(currentUser.getMemberId());
        updateBean.setFullName(request.getParameter("fullName"));
        updateBean.setPhone(request.getParameter("phone"));
        updateBean.setEmail(request.getParameter("email"));
        updateBean.setGender(request.getParameter("gender"));
        String bday = request.getParameter("birthday");
        if (bday != null && !bday.isEmpty()) updateBean.setBirthday(Date.valueOf(bday));
        updateBean.setMembershipLevel(currentUser.getMembershipLevel());
        if (service.updateProfile(updateBean)) {
            session.setAttribute("user", service.getMemberById(currentUser.getMemberId()));
            response.sendRedirect("MembersServlet?action=showProfile&msg=ok");
        }
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.getSession().invalidate();
        response.sendRedirect("MembersServlet?action=showLogin");
    }
}