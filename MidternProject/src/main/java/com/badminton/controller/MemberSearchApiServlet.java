package com.badminton.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.badminton.model.MembersBean;
import com.badminton.service.MembersService;

/**
 * 會員模糊搜尋 API (供 AJAX 呼叫)
 * GET /api/memberSearch?keyword=王
 * 回傳 JSON: { "success": true, "members": [{ "id": 1, "name": "王小明", "phone": "0911-111-111" }, ...] }
 */
@WebServlet("/api/memberSearch")
public class MemberSearchApiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        PrintWriter out = response.getWriter();
        
        try {
            String keyword = request.getParameter("keyword");

            if (keyword == null || keyword.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"請輸入搜尋關鍵字\"}");
                return;
            }

            MembersService service = new MembersService();
            List<MembersBean> members = service.searchMembers(keyword.trim());

            if (members != null && !members.isEmpty()) {
                StringBuilder sb = new StringBuilder();
                sb.append("{\"success\": true, \"members\": [");
                for (int i = 0; i < members.size(); i++) {
                    MembersBean m = members.get(i);
                    if (i > 0) sb.append(",");
                    sb.append(String.format(
                        "{\"id\": %d, \"name\": \"%s\", \"phone\": \"%s\"}",
                        m.getMemberId(),
                        m.getFullName() != null ? m.getFullName().replace("\"", "\\\"") : "",
                        m.getPhone() != null ? m.getPhone().replace("\"", "\\\"") : ""
                    ));
                }
                sb.append("]}");
                out.print(sb.toString());
            } else {
                out.print("{\"success\": false, \"message\": \"找不到符合的會員\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"伺服器錯誤: " + e.getMessage().replace("\"", "") + "\"}");
        }
    }
}
