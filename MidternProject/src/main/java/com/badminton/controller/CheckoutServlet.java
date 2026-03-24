package com.badminton.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.badminton.model.*;
import com.badminton.service.OrderService;


	@WebServlet("/checkout")
	public class CheckoutServlet extends HttpServlet {
		
		private static final long serialVersionUID = 1L;
		private OrderService orderService = new OrderService();
		
		/*
		 * 處理 POST 請求 (顧客按下「確認結帳」按鍵時觸發)
		 */
		@Override
		protected void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
			
			request.setCharacterEncoding("UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			
			try {
				// ===【第一步】把從表單/AJAX 傳來的資料拆出來===
	            int memberId      = Integer.parseInt(request.getParameter("memberId"));
	            int totalAmount   = Integer.parseInt(request.getParameter("totalAmount"));
	            String paymentType = request.getParameter("paymentType");
	            String note       = request.getParameter("note");

	            // 商品 ID 和數量是陣列（因為可能買多樣商品）
	            String[] productIds  = request.getParameterValues("productId");
	            String[] quantities  = request.getParameterValues("quantity");
	            String[] unitPrices  = request.getParameterValues("unitPrice");
	            String[] subtotals   = request.getParameterValues("subtotal");
	            
	         // ===【第二步】把資料打包成 Bean ===

	            // 主訂單便當
	            OrderBean order = new OrderBean();
	            order.setMemberId(memberId);
	            order.setTotalAmount(totalAmount);
	            order.setPaymentType(paymentType);
	            order.setNote(note);
	            
	         // 商品明細清單（可能是多筆）
	            List<OrderItemBean> items = new ArrayList<>();

	            if (productIds != null) {
	                for (int i = 0; i < productIds.length; i++) {
	                    OrderItemBean item = new OrderItemBean();
	                    item.setProductId(Integer.parseInt(productIds[i]));
	                    item.setQuantity(Integer.parseInt(quantities[i]));
	                    item.setUnitPrice(Integer.parseInt(unitPrices[i]));
	                    item.setSubtotal(Integer.parseInt(subtotals[i]));
	                    items.add(item);
	                }
	            }
	            // ===【第三步】叫 Service 店長去結帳 ===
	            boolean success = orderService.checkout(order, items);

	            // ===【第四步】根據結果，引導顧客到不同頁面 ===
	            if (success) {
	                // 把新訂單 ID 傳到成功頁面，讓它顯示「您的訂單號碼是 X」
	                request.setAttribute("orderId", order.getOrderId());
	                request.getRequestDispatcher("/WEB-INF/views/checkout_success.jsp")
	                        .forward(request, response);
	            } else {
	                request.setAttribute("errorMsg", "結帳失敗，請稍後再試。");
	                request.getRequestDispatcher("/WEB-INF/views/checkout_fail.jsp")
	                        .forward(request, response);
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	            request.setAttribute("errorMsg", "系統發生錯誤：" + e.getMessage());
	            request.getRequestDispatcher("/WEB-INF/views/checkout_fail.jsp")
	                    .forward(request, response);
	        }
	    }

	    /**
	     * 處理 GET 請求（直接在瀏覽器輸入 /checkout 時觸發）
	     * 通常直接重導回購物車頁面
	     */
	    @Override
	    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {
	        response.sendRedirect(request.getContextPath() + "/cart.jsp");
	    }
			}
			
			
		
	


