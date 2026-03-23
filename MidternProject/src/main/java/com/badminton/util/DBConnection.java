package com.badminton.util;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class DBConnection {
    
    private static DataSource ds;

    static {
        try {
            // 建立 JNDI 初始 Context
            Context context = new InitialContext();
            
            // 透過 JNDI 尋找 Tomcat 管理的 DataSource
            // 注意：前綴 "java:comp/env/" 是 Tomcat 規定的標準環境前綴，後面接你的資源名稱
            ds = (DataSource) context.lookup("java:comp/env/jdbc/BadmintonDB");
            
        } catch (NamingException e) {
            e.printStackTrace();
            throw new RuntimeException("JNDI 尋找 DataSource 失敗：" + e.getMessage());
        }
    }

    /**
     * 從 Tomcat 連線池中取得一條 Connection
     * * @return Connection 物件
     * @throws SQLException 若連線失敗，會拋出此例外
     */
    public static Connection getConnection() throws SQLException {
        // 直接從 DataSource 拿連線，不用再管 URL, User, Password
        return ds.getConnection();
    }
}