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

/**
 * OrderListServlet（加強版）
 *
 * GET /orderList                              → 全部訂單
 * GET /orderList?status=PENDING               → 狀態 Tab 篩選
 * GET /orderList?keyword=xxx&searchField=all  → 模糊搜尋
 * GET /orderList?keyword=1&searchField=memberId → 精準搜尋會員
 * 組合：?status=PAID&keyword=信用卡&searchField=paymentType
 */
@WebServlet("/orderList")
public class OrderListServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OrderDAO     orderDAO     = new OrderDAO();
    private OrderItemDAO orderItemDAO = new OrderItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ── 1. 讀取搜尋參數 ──────────────────────────
        String keyword     = request.getParameter("keyword");
        String searchField = request.getParameter("searchField");   // all/memberId/status/paymentType/note
        String statusTab   = request.getParameter("status");         // Tab 篩選

        // ── 2. 搜尋歷史（Session 儲存，最多保留 10 筆） ──
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<String> history = (List<String>) session.getAttribute("searchHistory");
        if (history == null) history = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            String entry = "[" + (searchField != null ? searchField : "all") + "] " + keyword.trim();
            history.remove(entry);          // 去重
            history.add(0, entry);          // 最新放最前
            if (history.size() > 10) history = history.subList(0, 10);
            session.setAttribute("searchHistory", history);
        }

        // ── 3. 取得訂單列表 ───────────────────────────
        List<OrderBean> allOrders;
        if (keyword != null && !keyword.trim().isEmpty()) {
            allOrders = orderDAO.findByKeyword(keyword.trim(), searchField);
        } else {
            allOrders = orderDAO.findAll();
        }

        // ── 4. Tab 狀態再做二次篩選 ──────────────────
        List<OrderBean> filtered = new ArrayList<>();
        for (OrderBean o : allOrders) {
            if (statusTab != null && !statusTab.isEmpty()
                    && !statusTab.equals(o.getStatus())) continue;
            filtered.add(o);
        }

        // ── 5. 預載每筆訂單的 OrderItems（JOIN Products）──
        Map<Integer, List<OrderItemBean>> itemMap = new HashMap<>();
        for (OrderBean o : filtered) {
            itemMap.put(o.getOrderId(), orderItemDAO.findByOrderId(o.getOrderId()));
        }

        // ── 6. 傳入 Request Scope ──────────────────────
        request.setAttribute("orderList",    filtered);
        request.setAttribute("itemMap",      itemMap);
        request.setAttribute("statusFilter", statusTab   != null ? statusTab   : "");
        request.setAttribute("keyword",      keyword     != null ? keyword     : "");
        request.setAttribute("searchField",  searchField != null ? searchField : "all");
        request.setAttribute("searchHistory", history);

        request.getRequestDispatcher("/WEB-INF/views/order_list.jsp")
               .forward(request, response);
    }
 // ===== 更新 =====
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
    	// ✅ 就加在這裡（最上面）
        System.out.println("🔥 有進到 doPost");
        System.out.println("action=" + request.getParameter("action"));
        System.out.println("orderId=" + request.getParameter("orderId"));
        System.out.println("status=" + request.getParameter("status"));
        System.out.println("paymentType=" + request.getParameter("paymentType"));

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {

            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            String paymentType = request.getParameter("paymentType");
            String note = request.getParameter("note");

            System.out.println("更新訂單：" + orderId);
            System.out.println("status=" + status);
            System.out.println("paymentType=" + paymentType);
            System.out.println("note=" + note);

            boolean result = orderDAO.updateOrder(orderId, status, paymentType, note);

            System.out.println("更新結果：" + result);

            // ⚠️ 這裡很關鍵：AJAX 必須回 JSON，不可以 redirect
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":" + result + "}");
            return;
        }
    }
}
