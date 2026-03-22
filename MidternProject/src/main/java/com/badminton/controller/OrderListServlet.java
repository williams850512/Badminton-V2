package com.badminton.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.badminton.dao.OrderDAO;
import com.badminton.dao.OrderItemDAO;
import com.badminton.model.OrderBean;
import com.badminton.model.OrderItemBean;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orderList")
public class OrderListServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OrderDAO     orderDAO     = new OrderDAO();
    private OrderItemDAO orderItemDAO = new OrderItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ── 0. 處理 AJAX 刪除歷史紀錄 ──────────────
        String delHistIdx = request.getParameter("_delHist");
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<String> history = (List<String>) session.getAttribute("searchHistory");
        
        if (delHistIdx != null && history != null) {
            try {
                int idx = Integer.parseInt(delHistIdx);
                if (idx >= 0 && idx < history.size()) {
                    history.remove(idx);
                    session.setAttribute("searchHistory", history);
                }
            } catch (Exception e) {}
            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        // ── 1. 讀取新的全能搜尋參數 ──────────────────────────
        String keyword   = request.getParameter("keyword");
        String minStr    = request.getParameter("minPrice");
        String maxStr    = request.getParameter("maxPrice");
        String statusTab = request.getParameter("status"); 
        
        Integer minPrice = null;
        Integer maxPrice = null;
        try { if (minStr != null && !minStr.isEmpty()) minPrice = Integer.parseInt(minStr); } catch(Exception e){}
        try { if (maxStr != null && !maxStr.isEmpty()) maxPrice = Integer.parseInt(maxStr); } catch(Exception e){}

        // ── 2. 搜尋歷史（只記錄關鍵字） ────────────────────
        if (history == null) history = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            String entry = keyword.trim();
            history.remove(entry);          
            history.add(0, entry);          
            if (history.size() > 10) history = history.subList(0, 10);
            session.setAttribute("searchHistory", history);
        }

        // ── 3. 取得訂單列表 (呼叫終極搜尋) ──
        List<OrderBean> allOrders;
        if ((keyword != null && !keyword.trim().isEmpty()) || minPrice != null || maxPrice != null) {
            allOrders = orderDAO.findByAdvancedSearch(keyword, minPrice, maxPrice);
        } else {
            allOrders = orderDAO.findAll();
        }

        // ── 4. Tab 狀態二次篩選 ──────────────────
        List<OrderBean> filtered = new ArrayList<>();
        if (allOrders != null) {
            for (OrderBean o : allOrders) {
                if (statusTab != null && !statusTab.isEmpty() && !statusTab.equals(o.getStatus())) continue;
                filtered.add(o);
            }
        }

        // ── 5. 預載明細 ──────────────────────────
        Map<Integer, List<OrderItemBean>> itemMap = new HashMap<>();
        for (OrderBean o : filtered) {
            itemMap.put(o.getOrderId(), orderItemDAO.findByOrderId(o.getOrderId()));
        }

        // ── 6. 傳入 Request Scope ──────────────────────
        request.setAttribute("orderList",     filtered);
        request.setAttribute("itemMap",       itemMap);
        request.setAttribute("statusFilter",  statusTab != null ? statusTab : "");
        request.setAttribute("keyword",       keyword   != null ? keyword   : "");
        request.setAttribute("minPrice",      minPrice  != null ? minPrice  : "");
        request.setAttribute("maxPrice",      maxPrice  != null ? maxPrice  : "");
        request.setAttribute("searchHistory", history);

        request.getRequestDispatcher("/WEB-INF/views/order_list.jsp").forward(request, response);
    }
}