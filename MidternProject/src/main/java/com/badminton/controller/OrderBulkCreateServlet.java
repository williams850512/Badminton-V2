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
 * 處理高併發情境下的「批次新增訂單」
 */
@WebServlet("/adminBulkCheckout")
public class OrderBulkCreateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO = new OrderDAO();
    private OrderItemDAO orderItemDAO = new OrderItemDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 核心解密：拿到存活的訂單編號陣列 (例如 "1,3,4")
        String activeIndicesStr = request.getParameter("activeOrderIndices");
        if (activeIndicesStr == null || activeIndicesStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orderList");
            return;
        }

        String[] orderIndices = activeIndicesStr.split(",");

        // 🚀 啟動超級大交易 (Super Transaction)
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // 關閉自動確認，啟動絕對防護罩

            try {
                // 跑迴圈，一張一張處理訂單
                for (String idx : orderIndices) {
                    idx = idx.trim();

                    // 1. 取得該訂單的標頭資料
                    int memberId = Integer.parseInt(request.getParameter("memberId_" + idx));
                    String paymentType = request.getParameter("paymentType_" + idx);
                    String status = request.getParameter("status_" + idx);
                    String note = request.getParameter("note_" + idx);
                    int totalAmount = Integer.parseInt(request.getParameter("totalAmount_" + idx));

                    // 準備主訂單 Bean
                    OrderBean order = new OrderBean();
                    order.setMemberId(memberId);
                    order.setPaymentType(paymentType);
                    order.setStatus(status);
                    order.setNote(note);
                    order.setTotalAmount(totalAmount);

                    // 寫入主訂單 (大廚發威)
                    boolean isOrderInserted = orderDAO.insertWithConnection(conn, order);
                    if (!isOrderInserted) throw new SQLException("批次作業中斷：訂單標頭新增失敗！");

                    int newOrderId = order.getOrderId(); // 取得剛產生的真實在資料庫的 ID

                    // 2. 取得這張訂單底下的所有「商品明細陣列」
                    String[] productIds = request.getParameterValues("productId_" + idx);
                    String[] quantities = request.getParameterValues("quantity_" + idx);
                    String[] unitPrices = request.getParameterValues("unitPrice_" + idx);
                    String[] subtotals = request.getParameterValues("subtotal_" + idx);

                    if (productIds != null) {
                        for (int i = 0; i < productIds.length; i++) {
                            if (productIds[i] == null || productIds[i].trim().isEmpty()) continue;

                            OrderItemBean item = new OrderItemBean();
                            item.setOrderId(newOrderId); // 綁定真實的訂單 ID
                            item.setProductId(Integer.parseInt(productIds[i]));
                            item.setQuantity(Integer.parseInt(quantities[i]));
                            item.setUnitPrice(Integer.parseInt(unitPrices[i]));
                            item.setSubtotal(Integer.parseInt(subtotals[i]));

                            boolean isItemInserted = orderItemDAO.insertWithConnection(conn, item);
                            if (!isItemInserted) throw new SQLException("批次作業中斷：明細新增失敗！");
                        }
                    }
                }

                // 🌟 全部訂單與明細都寫入成功，蓋章確認！
                conn.commit();
                System.out.println("✅ 批次大交易成功！共新增了 " + orderIndices.length + " 筆訂單。");

                // 成功後直接回到列表
                response.sendRedirect(request.getContextPath() + "/views/orderList");

            } catch (Exception e) {
                // ❌ 只要有任何一張訂單、任何一項商品出錯，全部退回！
                conn.rollback();
                System.err.println("❌ 批次交易失敗，已啟動安全防護退回：");
                e.printStackTrace();
                
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().print("<script>alert('批次新增失敗，資料已安全退回：" + e.getMessage() + "'); history.back();</script>");
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}