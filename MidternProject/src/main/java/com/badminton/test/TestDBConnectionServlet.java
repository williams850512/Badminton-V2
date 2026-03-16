package com.badminton.test;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;


import javax.naming.Context;
import javax.naming.InitialContext;

import javax.sql.DataSource;


@WebServlet("/TestDBConnectionServlet")
public class TestDBConnectionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    
    public TestDBConnectionServlet() {
        
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		try {
            // 1. 初始化 JNDI 上下文
            Context initContext = new InitialContext();
           
            
            // 2. 透過名稱尋找 DataSource
            
            DataSource ds = (DataSource) initContext.lookup("java:comp/env/jdbc/BadmintonDB");
            
            // 3. 嘗試取得連線
            try (Connection conn = ds.getConnection()) {
                if (conn != null && !conn.isClosed()) {
                    out.println("成功！已連線至 SQL Server。");
                }
            }
        } catch (Exception e) {
            out.println("失敗： " + e.getMessage());
            e.printStackTrace(out);
        }
       }
    

	
		

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
