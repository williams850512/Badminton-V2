package com.badminton.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import com.badminton.dao.OrderDAO;
import com.badminton.dao.OrderItemDAO;
import com.badminton.model.OrderBean;
import com.badminton.model.OrderItemBean;
import com.badminton.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 處理後台管理員新增訂單 (大魔王關卡)
 */
@WebServlet("/adminCheckout") // 對應 JSP 裡的 action="/adminCheckout(149行, 注意大小寫不然會連不到)"
public class OrderCreateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO = new OrderDAO();
    private OrderItemDAO orderItemDAO = new OrderItemDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        try {
            // ── 1. 接收主訂單基本資料 ──
            int memberId = Integer.parseInt(request.getParameter("memberId"));
            String paymentType = request.getParameter("paymentType");
            String status = request.getParameter("status");
            String note = request.getParameter("note");
            int totalAmount = Integer.parseInt(request.getParameter("totalAmount"));

            // ── 2. 接收明細資料 (動態表單，使用 getParameterValues 接收陣列) ──
            String[] productIds = request.getParameterValues("productId");
            String[] quantities = request.getParameterValues("quantity");
            String[] unitPrices = request.getParameterValues("unitPrice");
            String[] subtotals  = request.getParameterValues("subtotal");

            // ── 3. 準備主訂單 Bean ──
            OrderBean order = new OrderBean();
            order.setMemberId(memberId);
            order.setPaymentType(paymentType);
            order.setStatus(status);
            order.setNote(note);
            order.setTotalAmount(totalAmount);

            // ── 4. 啟動資料庫交易 (Transaction) ──
            // 取得連線，準備做「不成功，便成仁」的綁定寫入
            try (Connection conn = DBConnection.getConnection()) {
                
                // 🔥 核心防護機制：關閉自動確認，改為手動控制
                conn.setAutoCommit(false); 

                try {
                    // 步驟 A：大廚先寫入主訂單，並把新產生的流水號 (orderId) 塞回 order 物件
                    boolean isOrderInserted = orderDAO.insertWithConnection(conn, order);
                    if (!isOrderInserted) {
                        throw new SQLException("主訂單新增失敗！");
                    }

                    int newOrderId = order.getOrderId(); // 拿到熱騰騰的新訂單 ID

                    // 步驟 B：迴圈處理陣列，寫入每一筆商品明細
                    if (productIds != null) {
                        for (int i = 0; i < productIds.length; i++) {
                            // 防呆：如果這一列的商品 ID 是空的就跳過
                            if (productIds[i] == null || productIds[i].trim().isEmpty()) continue;
                            
                            OrderItemBean item = new OrderItemBean();
                            item.setOrderId(newOrderId); // 把明細綁定到剛剛的主訂單 ID
                            item.setProductId(Integer.parseInt(productIds[i]));
                            item.setQuantity(Integer.parseInt(quantities[i]));
                            item.setUnitPrice(Integer.parseInt(unitPrices[i]));
                            item.setSubtotal(Integer.parseInt(subtotals[i]));

                            boolean isItemInserted = orderItemDAO.insertWithConnection(conn, item);
                            if (!isItemInserted) {
                                throw new SQLException("第 " + (i + 1) + " 項商品明細新增失敗！");
                            }
                        }
                    }

                    // 步驟 C：全部寫入成功，蓋章確認 (Commit)
                    conn.commit();
                    System.out.println("✅ 交易成功！建立新訂單 #" + newOrderId);

                } catch (SQLException e) {
                    // ❌ 只要有任何一個步驟出錯，全部退回原狀 (Rollback)
                    conn.rollback();
                    System.err.println("❌ 交易失敗，已安全退回資料庫狀態。");
                    throw e; // 拋出給外層處理
                } finally {
                    conn.setAutoCommit(true); // 恢復連線的預設狀態
                }
            }

            // ── 5. 成功後導回訂單列表 ──
            response.sendRedirect(request.getContextPath() + "/orderList");

        } catch (Exception e) {
            e.printStackTrace();
            // 如果發生錯誤（如沒填資料、資料庫連線失敗），跳出警示並留在原頁面
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().print("<script>alert('新增訂單失敗：" + e.getMessage() + "'); history.back();</script>");
        }
    }
}