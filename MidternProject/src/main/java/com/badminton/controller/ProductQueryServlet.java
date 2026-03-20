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

@WebServlet("/api/productQuery")
public class ProductQueryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 設定回傳格式為 JSON 以及編碼
        response.setContentType("application/json;charset=UTF-8");
        
        String idParam = request.getParameter("id");
        String nameParam = request.getParameter("name");
        
        ProductDAO dao = new ProductDAO();
        ProductBean product = null;

        // 判斷前端傳來的是 ID 還是 名稱
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                product = dao.getProductById(id);
            } catch (NumberFormatException e) {
                // ID 格式錯誤
                e.printStackTrace();
            }
        } else if (nameParam != null && !nameParam.trim().isEmpty()) {
            product = dao.getProductByName(nameParam);
        }

        // 準備回傳給前端的 JSON 輸出
        PrintWriter out = response.getWriter();
        
        if (product != null) {
            // 實務上建議用 Gson 函式庫來轉 JSON，這裡示範手動組裝 JSON 字串
            String jsonResponse = String.format(
                "{\"success\": true, \"product\": {\"id\": %d, \"name\": \"%s\", \"price\": %.2f}}",
                product.getProductId(),
                product.getProductName(),
                product.getPrice()
            );
            out.print(jsonResponse);
        } else {
            // 找不到該商品或商品已下架
            out.print("{\"success\": false}");
        }
    }
}