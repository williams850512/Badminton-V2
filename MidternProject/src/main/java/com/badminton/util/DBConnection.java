package com.badminton.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	        private static final String URL = "";
			private static final String USERNAME = "";
			private static final String PASSWORD = "";
			
			static {
	        	try {
	        		Class.forName("com.mysql.cj.jdbc.Driver");
	        	} catch (ClassNotFoundException e) {
	        		e.printStackTrace();
	        		throw new RuntimeException("無法載入資料庫驅動程式:" + e.getMessage());
	        	}
	        }
			/*
			 * 
			@return Connection 物件
			@throws SQLException  若連線失敗，會拋出此例外	
			 * 
			 */
			public static Connection getConnection() throws SQLException{
				return DriverManager.getConnection(URL, USERNAME, PASSWORD);
			}
			
			
			

}
