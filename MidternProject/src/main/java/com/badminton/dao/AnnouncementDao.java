package com.badminton.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import com.badminton.model.AnnouncementBean;

public class AnnouncementDao {
	// 請注意連線資訊！
//    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=BadmintonDB;encrypt=false;";
//    private static final String DB_USER = "yun";
//    private static final String DB_PASS = "0000";

    // 取得資料庫連線的共用方法
	private Connection getConnection() throws SQLException {
        try {
            Context context = new InitialContext();
            // 這裡對應你 context.xml 裡面的 name="jdbc/BadmintonDB"
            // (註：老師範例是 java:/comp/env...，但在標準 Tomcat 中，java:comp/env... 不加斜線是比較標準且不易出錯的寫法)
            DataSource ds = (DataSource) context.lookup("java:comp/env/jdbc/BadmintonDB");
            return ds.getConnection();
        } catch (NamingException e) {
            e.printStackTrace();
            throw new SQLException("JNDI 尋找資料庫連線失敗: " + e.getMessage());
        }
    }

    // 1. 新增公告 (Insert)
    public boolean addAnnouncement(AnnouncementBean bean) {
        String sql = "INSERT INTO Announcements (title, content, status, is_pinned, category, publish_at, expire_at) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        // try-with-resources 會關閉 conn 與 pstmt
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, bean.getTitle());
            pstmt.setString(2, bean.getContent());
            pstmt.setString(3, bean.getStatus() != null ? bean.getStatus() : "draft");
            pstmt.setBoolean(4, bean.getIsPinned() != null ? bean.getIsPinned() : false);
            pstmt.setString(5, bean.getCategory());
            pstmt.setTimestamp(6, bean.getPublishAt());
            pstmt.setTimestamp(7, bean.getExpireAt());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
        	try {
				pstmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
            try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
        }
    }
    
    // 查詢所有公告 -> 前台與後台列表會用到
    public List<AnnouncementBean> getAllAnnouncements() {
        List<AnnouncementBean> list = new ArrayList<>();
        // 排序邏輯：置頂的放最前面，接著依照建立時間由新到舊排
        String sql = "SELECT * FROM Announcements ORDER BY is_pinned DESC, created_at DESC";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                AnnouncementBean bean = new AnnouncementBean();
                bean.setAnnouncementId(rs.getInt("announcement_id"));
                bean.setTitle(rs.getString("title"));
                bean.setContent(rs.getString("content"));
                bean.setStatus(rs.getString("status"));
                bean.setIsPinned(rs.getBoolean("is_pinned"));
                bean.setCreatedAt(rs.getTimestamp("created_at"));
                bean.setCategory(rs.getString("category"));
                bean.setViewCount(rs.getInt("view_count"));
                bean.setPublishAt(rs.getTimestamp("publish_at"));
                bean.setExpireAt(rs.getTimestamp("expire_at"));
                bean.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                list.add(bean);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
				rs.close();
				pstmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
            
        }
        return list;
    }
    
    // ID查詢單筆 -> 用在編輯公告時把舊資料撈出來顯示
    public AnnouncementBean getAnnouncementById(int id) {
        AnnouncementBean bean = null;
        String sql = "SELECT * FROM Announcements WHERE announcement_id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                bean = new AnnouncementBean();
                bean.setAnnouncementId(rs.getInt("announcement_id"));
                bean.setTitle(rs.getString("title"));
                bean.setContent(rs.getString("content"));
                bean.setStatus(rs.getString("status"));
                bean.setIsPinned(rs.getBoolean("is_pinned"));
                bean.setCreatedAt(rs.getTimestamp("created_at"));
                bean.setCategory(rs.getString("category"));
                bean.setViewCount(rs.getInt("view_count"));
                bean.setPublishAt(rs.getTimestamp("publish_at"));
                bean.setExpireAt(rs.getTimestamp("expire_at"));
                bean.setUpdatedAt(rs.getTimestamp("updated_at"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return bean;
    }
    
    // 新增：模糊搜尋公告
    public List<AnnouncementBean> searchAnnouncements(String keyword) {
        List<AnnouncementBean> list = new ArrayList<>();
        // 使用 LIKE 來比對標題或內容包含該關鍵字
        String sql = "SELECT * FROM Announcements WHERE title LIKE ? OR content LIKE ? ORDER BY is_pinned DESC, created_at DESC";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            // 幫關鍵字前後加上 %，代表「只要有包含就算數」
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                AnnouncementBean bean = new AnnouncementBean();
                bean.setAnnouncementId(rs.getInt("announcement_id"));
                bean.setTitle(rs.getString("title"));
                bean.setContent(rs.getString("content"));
                bean.setStatus(rs.getString("status"));
                bean.setIsPinned(rs.getBoolean("is_pinned"));
                bean.setCreatedAt(rs.getTimestamp("created_at"));
                bean.setCategory(rs.getString("category"));
                bean.setViewCount(rs.getInt("view_count"));
                bean.setPublishAt(rs.getTimestamp("publish_at"));
                bean.setExpireAt(rs.getTimestamp("expire_at"));
                
                list.add(bean);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return list;
    }

    // 修改 Update
    public boolean updateAnnouncement(AnnouncementBean bean) {
        // 注意：這裡我們順便更新了 updated_at 為當前時間 (GETDATE())
        String sql = "UPDATE Announcements SET title=?, content=?, status=?, is_pinned=?, category=?, "
                   + "publish_at=?, expire_at=?, updated_at=GETDATE() WHERE announcement_id=?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, bean.getTitle());
            pstmt.setString(2, bean.getContent());
            pstmt.setString(3, bean.getStatus());
            pstmt.setBoolean(4, bean.getIsPinned());
            pstmt.setString(5, bean.getCategory());
            pstmt.setTimestamp(6, bean.getPublishAt());
            pstmt.setTimestamp(7, bean.getExpireAt());
            pstmt.setInt(8, bean.getAnnouncementId()); // 指定要修改哪一筆
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // 刪除 Delete
    public boolean deleteAnnouncement(int id) {
        String sql = "DELETE FROM Announcements WHERE announcement_id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    
    // 測試資料庫有沒有連線成功
//    public static void main(String[] args) {
//        AnnouncementDao dao = new AnnouncementDao();
//        try {
//            System.out.println("正在嘗試連線到 MSSQL...");
//            Connection conn = dao.getConnection(); // 呼叫你剛寫好的連線方法
//            
//            if (conn != null && !conn.isClosed()) {
//                System.out.println("資料庫連線成功！");
//                conn.close(); // 測試完把連線關掉
//            }
//        } catch (Exception e) {
//            System.out.println("連線失敗了！請看錯誤訊息：");
//            e.printStackTrace(); // 印出詳細錯誤原因
//        }
//    }
}