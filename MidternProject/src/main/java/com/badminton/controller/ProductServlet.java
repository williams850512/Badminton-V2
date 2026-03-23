package com.badminton.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.badminton.dao.ProductDao;
import com.badminton.model.ProductBean;
import com.badminton.service.ProductService;

	
@MultipartConfig
@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       


    public ProductServlet() {
        super();

    
    
    }

    ProductService productService = new ProductService();
//    ProductDao productDao = new ProductDao();

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String action = request.getParameter("action");
		
//		if (action == null) {
//			action="productIndex";
//		}
		if (action == null) {
			action="productIndex";
		}
		
		
		
		   switch (action) {
	        case "productIndex":
	            request.getRequestDispatcher("/WEB-INF/views/productIndex.jsp").forward(request, response);
	            break;

	        case "productList":
	            List<ProductBean> products = productService.showProduct();
	            request.setAttribute("products", products);
	            request.getRequestDispatcher("/WEB-INF/views/productList.jsp").forward(request, response);
	            break;
	            
	        case "searchProduct":
	            String keyword = request.getParameter("keyword");
	            List<ProductBean> searchResults = productService.searchProductsByKeyword(keyword);
	            request.setAttribute("products", searchResults);
	            request.setAttribute("keyword", keyword);
	            request.getRequestDispatcher("/WEB-INF/views/productList.jsp").forward(request, response);
	            break;

	        case "productInsertForm":
	            request.getRequestDispatcher("/WEB-INF/views/productInsert.jsp").forward(request, response);
	            break;

	        case "productUpdateForm":
	            Integer productId = Integer.parseInt(request.getParameter("productId"));
	            ProductBean product = productService.getProductById(productId);
	            request.setAttribute("product", product);
	            request.getRequestDispatcher("/WEB-INF/views/productUpdate.jsp").forward(request, response);
	            break;

	        default:
	            response.sendRedirect(request.getContextPath() + "/ProductServlet?action=productIndex");
//	            request.getRequestDispatcher("/WEB-INF/views/productIndex.jsp").forward(request, response);

	            break;
		}
		
		
			
		
	
		
		
		

	}



	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
//		doGet(request, response);
		String action = request.getParameter("action");

	    if (action == null) {
	        response.sendRedirect(request.getContextPath() + "/ProductServlet?action=productIndex");
	        return;
	    }

	    switch (action) {
	        case "productInsert":
	            productService.insertProduct(request);
	            response.sendRedirect(request.getContextPath() + "/ProductServlet?action=productList");
	            break;

	        case "productUpdate":
	            productService.updateProduct(request);
	            response.sendRedirect(request.getContextPath() + "/ProductServlet?action=productList");
	            break;

	        case "productDelete":
	            Integer productId = Integer.parseInt(request.getParameter("productId"));
	            productService.deleteProduct(productId);
	            response.sendRedirect(request.getContextPath() + "/ProductServlet?action=productList");
	            break;

	        default:
	            response.sendRedirect(request.getContextPath() + "/ProductServlet?action=productIndex");
	            break;
	    }
		
		
		
		
		
	}

}
