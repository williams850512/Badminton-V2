package com.badminton.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	        private static final String URL = "jdbc:sqlserver://localhost:1433;DatabaseName=BadmindonDBTest;encrypt=false";
			private static final String USERNAME = "tony";
			private static final String PASSWORD = "7410";
			
			static {
	        	try {
	        		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
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
