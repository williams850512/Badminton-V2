package com.badminton.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// 加入 JNDI 需要的 import
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import com.badminton.model.AnnouncementBean;

public class AnnouncementDao {

    // 取得資料庫連線的共用方法 (已改為 JNDI 模式)
    private Connection getConnection() throws SQLException {
        try {
            Context context = new InitialContext();
            // 注意：這裡的 "jdbc/BadmintonDB" 必須跟你在 Tomcat 的 context.xml 中設定的名稱一致
            DataSource ds = (DataSource) context.lookup("java:/comp/env/jdbc/BadmintonDB");
            return ds.getConnection();
        } catch (NamingException e) {
            e.printStackTrace();
            throw new SQLException("JNDI 尋找資料來源失敗: " + e.getMessage());
        }
    }

    // 1. 新增公告 (Insert)
    public boolean addAnnouncement(AnnouncementBean bean) {
        String sql = "INSERT INTO Announcements (title, content, status, is_pinned, category, publish_at, expire_at) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
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
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    
    // 查詢所有公告
    public List<AnnouncementBean> getAllAnnouncements() {
        List<AnnouncementBean> list = new ArrayList<>();
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
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return list;
    }
    
    // ID查詢單筆
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
    
    // 模糊搜尋公告
    public List<AnnouncementBean> searchAnnouncements(String keyword) {
        List<AnnouncementBean> list = new ArrayList<>();
        String sql = "SELECT * FROM Announcements WHERE title LIKE ? OR content LIKE ? ORDER BY is_pinned DESC, created_at DESC";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
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
            pstmt.setInt(8, bean.getAnnouncementId());
            
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
}