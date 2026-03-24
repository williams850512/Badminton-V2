package com.badminton.controller;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.badminton.dao.ProductDAO;
import com.badminton.model.ProductBean;
import com.badminton.model.MembersBean;
import com.badminton.service.MembersService;

@WebServlet("/api/productQuery")
public class ProductQueryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        String idParam = request.getParameter("id");
        String nameParam = request.getParameter("name");
        String keyword = request.getParameter("keyword");
        
        ProductDAO dao = new ProductDAO();
        PrintWriter out = response.getWriter();
        String type = request.getParameter("type");

        // ===== 會員模糊搜尋模式 (type=member) =====
        if ("member".equals(type) && keyword != null && !keyword.trim().isEmpty()) {
            try {
                MembersService memberService = new MembersService();
                java.util.List<MembersBean> members = memberService.searchMembers(keyword.trim());
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
                out.print("{\"success\": false, \"message\": \"會員搜尋錯誤\"}");
            }
            return;
        }

        // ===== 模糊搜尋模式 (keyword) =====
        if (keyword != null && !keyword.trim().isEmpty()) {
            try {
                java.util.List<ProductBean> products = dao.searchProducts(keyword.trim());
                if (products != null && !products.isEmpty()) {
                    StringBuilder sb = new StringBuilder();
                    sb.append("{\"success\": true, \"products\": [");
                    for (int i = 0; i < products.size(); i++) {
                        ProductBean p = products.get(i);
                        if (i > 0) sb.append(",");
                        sb.append(String.format(
                            "{\"id\": %d, \"name\": \"%s\", \"price\": %d}",
                            p.getProductId(),
                            p.getProductName() != null ? p.getProductName().replace("\"", "\\\"") : "",
                            (int) p.getPrice()
                        ));
                    }
                    sb.append("]}");
                    out.print(sb.toString());
                } else {
                    out.print("{\"success\": false, \"message\": \"找不到符合的商品\"}");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.print("{\"success\": false, \"message\": \"伺服器錯誤\"}");
            }
            return;
        }

        // ===== 原本的精準查詢模式 (id / name) =====
        ProductBean product = null;
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                product = dao.getProductById(id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        } else if (nameParam != null && !nameParam.trim().isEmpty()) {
            product = dao.getProductByName(nameParam);
        }

        if (product != null) {
        	String jsonResponse = String.format(
        	    "{\"success\": true, \"product\": {\"id\": %d, \"name\": \"%s\", \"price\": %d}}",
        	    product.getProductId(),
        	    product.getProductName().replace("\"", "\\\""),
        	    (int) product.getPrice()
        	);
            out.print(jsonResponse);
        } else {
            out.print("{\"success\": false}");
        }
    }
}