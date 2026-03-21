package com.badminton.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.naming.*;
import javax.sql.DataSource;
import com.badminton.model.MembersBean;

public class MembersDAO {
    private DataSource ds;

    public MembersDAO() {
        try {
            Context context = new InitialContext(); 
            ds = (DataSource) context.lookup("java:comp/env/jdbc/BadmintonDB");
        } catch (NamingException e) { e.printStackTrace(); }
    }

    /**
     * ✨ 會員登入驗證 (強制區分大小寫)
     * 加入 COLLATE Latin1_General_CS_AS 確保帳號與密碼大小寫必須完全相符
     */
    public MembersBean login(String username, String password) {
        // SQL Server 強制區分大小寫語法
        String selectSql = "SELECT * FROM Members WHERE " +
                           "username = ? COLLATE Latin1_General_CS_AS AND " +
                           "password = ? COLLATE Latin1_General_CS_AS";
                           
        String updateTimeSql = "UPDATE Members SET last_login_at = GETDATE() WHERE member_id = ?";
        
        try (Connection conn = ds.getConnection()) {
            // 1. 驗證帳號密碼
            try (PreparedStatement psSelect = conn.prepareStatement(selectSql)) {
                psSelect.setString(1, username);
                psSelect.setString(2, password);
                
                try (ResultSet rs = psSelect.executeQuery()) {
                    if (rs.next()) {
                        // 封裝成 Bean
                        MembersBean m = mapRowToBean(rs);
                        
                        // 2. 登入成功後，立即更新資料庫中的最後登入時間
                        try (PreparedStatement psUpdate = conn.prepareStatement(updateTimeSql)) {
                            psUpdate.setInt(1, m.getMemberId());
                            psUpdate.executeUpdate();
                        }
                        
                        return m;
                    }
                }
            }
        } catch (SQLException e) { 
            System.err.println("會員登入發生錯誤: " + e.getMessage());
            e.printStackTrace(); 
        }
        return null;
    }

    /**
     * ✨ 檢查帳號是否已存在 (用於註冊防重)
     * 這裡「不使用」COLLATE，目的是為了找出任何大小寫組合的同名帳號
     * 例如：資料庫有 Admin，有人想註冊 admin，此方法會回傳 true (已存在)
     */
    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM Members WHERE username = ?";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("檢查帳號重複失敗: " + e.getMessage());
        }
        return false;
    }

    /**
     * 取得所有會員列表
     */
    public List<MembersBean> getAllMembers() {
        List<MembersBean> list = new ArrayList<>();
        String sql = "SELECT * FROM Members ORDER BY member_id ASC";
        try (Connection conn = ds.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToBean(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /**
     * 關鍵字搜尋 (後台管理用)
     */
    public List<MembersBean> searchMembers(String keyword) {
        List<MembersBean> list = new ArrayList<>();
        
        String statusKeyword = keyword;
        if (keyword.contains("正常") || keyword.contains("啟用")) {
            statusKeyword = "Active";
        } else if (keyword.contains("停權") || keyword.contains("禁用")) {
            statusKeyword = "Suspended";
        }
        
        String levelKeyword = keyword;
        if (keyword.equalsIgnoreCase("一般") || keyword.contains("一般會員")) {
            levelKeyword = "Regular"; 
        } else if (keyword.equalsIgnoreCase("VIP")) {
            levelKeyword = "VIP";
        }

        String sql = "SELECT * FROM Members WHERE " +
                     "CAST(member_id AS VARCHAR) LIKE ? OR " +
                     "username LIKE ? OR " +
                     "full_name LIKE ? OR " +
                     "phone LIKE ? OR " +
                     "email LIKE ? OR " +
                     "CAST(birthday AS VARCHAR) LIKE ? OR " +
                     "status LIKE ? OR " +
                     "membership_level LIKE ? OR " +
                     "note LIKE ? " +
                     "ORDER BY member_id ASC";
        
        try (Connection conn = ds.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String wildKeyword = "%" + keyword + "%";
            ps.setString(1, wildKeyword); 
            ps.setString(2, wildKeyword); 
            ps.setString(3, wildKeyword); 
            ps.setString(4, wildKeyword); 
            ps.setString(5, wildKeyword); 
            ps.setString(6, wildKeyword); 
            ps.setString(7, "%" + statusKeyword + "%"); 
            ps.setString(8, "%" + levelKeyword + "%");
            ps.setString(9, wildKeyword);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToBean(rs));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /**
     * 更新會員詳細資料
     */
    public boolean updateMember(MembersBean m) {
        String sql = "UPDATE Members SET full_name=?, phone=?, email=?, gender=?, birthday=?, " +
                     "membership_level=?, status=?, note=?, updated_at=GETDATE() WHERE member_id=?";
        try (Connection conn = ds.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, m.getFullName());
            ps.setString(2, m.getPhone());
            ps.setString(3, m.getEmail());
            ps.setString(4, m.getGender());
            ps.setDate(5, m.getBirthday());
            ps.setString(6, m.getMembershipLevel());
            ps.setString(7, m.getStatus());
            ps.setString(8, m.getNote());
            ps.setInt(9, m.getMemberId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /**
     * ✨ 專門更新備註
     */
    public boolean updateNote(int memberId, String note) {
        String sql = "UPDATE Members SET note = ?, updated_at = GETDATE() WHERE member_id = ?";
        try (Connection conn = ds.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, note);
            ps.setInt(2, memberId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /**
     * 會員註冊
     */
    public boolean register(MembersBean m) {
        String sql = "INSERT INTO Members (username, password, full_name, phone, email, gender, birthday, membership_level, status, note, created_at) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?, GETDATE())";
        try (Connection conn = ds.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, m.getUsername());
            ps.setString(2, m.getPassword());
            ps.setString(3, m.getFullName());
            ps.setString(4, m.getPhone());
            ps.setString(5, m.getEmail());
            ps.setString(6, m.getGender());
            ps.setDate(7, m.getBirthday());
            ps.setString(8, m.getMembershipLevel());
            ps.setString(9, "Active"); 
            ps.setString(10, m.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public MembersBean getMemberById(int id) {
        String sql = "SELECT * FROM Members WHERE member_id = ?";
        try (Connection conn = ds.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToBean(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean deleteMember(int id) {
        String sql = "DELETE FROM Members WHERE member_id = ?";
        try (Connection conn = ds.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /**
     * 封裝 ResultSet 到 Bean (包含時區校正)
     */
    private MembersBean mapRowToBean(ResultSet rs) throws SQLException {
        MembersBean m = new MembersBean();
        m.setMemberId(rs.getInt("member_id"));
        m.setUsername(rs.getString("username"));
        m.setFullName(rs.getString("full_name"));
        m.setGender(rs.getString("gender"));
        m.setBirthday(rs.getDate("birthday"));
        m.setPhone(rs.getString("phone"));
        m.setEmail(rs.getString("email"));
        m.setMembershipLevel(rs.getString("membership_level"));
        m.setStatus(rs.getString("status"));
        m.setNote(rs.getString("note"));
        
        long offset = 8 * 60 * 60 * 1000;

        Timestamp lastLogin = rs.getTimestamp("last_login_at");
        if (lastLogin != null) {
            m.setLastLogin(new Timestamp(lastLogin.getTime() + offset)); 
        }
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            m.setCreatedAt(new Timestamp(createdAt.getTime() + offset)); 
        }
        
        return m;
    }
}