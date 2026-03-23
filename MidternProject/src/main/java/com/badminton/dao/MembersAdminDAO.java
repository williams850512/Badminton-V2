package com.badminton.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.naming.*;
import javax.sql.DataSource;
import com.badminton.model.MembersAdminBean;

public class MembersAdminDAO {
    private DataSource ds;

    public MembersAdminDAO() {
        try {
            Context context = new InitialContext();
            ds = (DataSource) context.lookup("java:comp/env/jdbc/BadmintonDB");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    /**
     * ✨ 管理員登入驗證 (強制區分大小寫)
     * 加入 COLLATE Latin1_General_CS_AS 強制 SQL Server 執行 Case-Sensitive 比較
     */
    public MembersAdminBean login(String username, String password) {
        String sql = "SELECT * FROM Admins WHERE " +
                     "username = ? COLLATE Latin1_General_CS_AS AND " +
                     "password = ? COLLATE Latin1_General_CS_AS AND " +
                     "status = 'active'";
                     
        try (Connection conn = ds.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MembersAdminBean admin = mapRowToAdminBean(rs);
                    // 登入成功後更新時間
                    updateLastLoginTime(admin.getAdminId());
                    return admin;
                }
            }
        } catch (SQLException e) {
            System.err.println("登入驗證發生錯誤: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * ✨ 新增：檢查管理員帳號是否已存在 (不區分大小寫檢查)
     * 用於新增管理員前，防止重複帳號
     */
    public boolean isAdminExists(String username) {
        String sql = "SELECT COUNT(*) FROM Admins WHERE username = ?";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 更新最後登入時間 (使用資料庫當前時間)
     */
    private void updateLastLoginTime(int adminId) {
        String sql = "UPDATE Admins SET last_login_at = GETDATE() WHERE admin_id = ?";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("更新登入時間失敗: " + e.getMessage());
        }
    }

    /**
     * 撈取所有管理員名單
     */
    public List<MembersAdminBean> getAllAdmins() {
        List<MembersAdminBean> list = new ArrayList<>();
        String sql = "SELECT * FROM Admins ORDER BY admin_id ASC";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToAdminBean(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 搜尋管理員 (支援 ID、帳號、姓名、電話、信箱模糊搜尋)
     */
    public List<MembersAdminBean> searchAdmins(String keyword) {
        List<MembersAdminBean> list = new ArrayList<>();
        String sql = "SELECT * FROM Admins WHERE " +
                     "CAST(admin_id AS VARCHAR) LIKE ? OR " +
                     "username LIKE ? OR " +
                     "full_name LIKE ? OR " +
                     "phone LIKE ? OR " +
                     "email LIKE ? " +
                     "ORDER BY admin_id ASC";
        
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ps.setString(5, searchPattern);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToAdminBean(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 根據 ID 取得單一管理員資料
     */
    public MembersAdminBean getAdminById(int id) {
        String sql = "SELECT * FROM Admins WHERE admin_id = ?";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToAdminBean(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 新增管理員
     */
    public boolean addAdmin(MembersAdminBean a) {
        String sql = "INSERT INTO Admins (username, password, full_name, gender, birthday, phone, email, role, status, note, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'active', ?, GETDATE())";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getUsername());
            ps.setString(2, a.getPassword());
            ps.setString(3, a.getFullName());
            ps.setString(4, a.getGender());
            ps.setDate(5, a.getBirthday());
            ps.setString(6, a.getPhone());
            ps.setString(7, a.getEmail());
            ps.setString(8, a.getRole());
            ps.setString(9, a.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 更新管理員詳細資料
     */
    public boolean updateAdmin(MembersAdminBean a) {
        String sql = "UPDATE Admins SET full_name=?, gender=?, birthday=?, phone=?, email=?, role=?, status=?, note=?, updated_at=GETDATE() WHERE admin_id=?";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getFullName());
            ps.setString(2, a.getGender());
            ps.setDate(3, a.getBirthday());
            ps.setString(4, a.getPhone());
            ps.setString(5, a.getEmail());
            ps.setString(6, a.getRole());
            ps.setString(7, a.getStatus());
            ps.setString(8, a.getNote());
            ps.setInt(9, a.getAdminId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ✨ 專門更新管理員備註
     */
    public boolean updateAdminNote(int id, String note) {
        String sql = "UPDATE Admins SET note = ?, updated_at = GETDATE() WHERE admin_id = ?";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, note);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("更新管理員備註失敗: " + e.getMessage());
            return false;
        }
    }

    /**
     * 刪除管理員
     */
    public boolean deleteAdmin(int id) {
        String sql = "DELETE FROM Admins WHERE admin_id = ?";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 將 ResultSet 封裝為 Bean 並執行時區偏移校正 (+8小時)
     */
    private MembersAdminBean mapRowToAdminBean(ResultSet rs) throws SQLException {
        MembersAdminBean a = new MembersAdminBean();
        a.setAdminId(rs.getInt("admin_id"));
        a.setUsername(rs.getString("username"));
        a.setFullName(rs.getString("full_name"));
        a.setGender(rs.getString("gender"));
        a.setBirthday(rs.getDate("birthday"));
        a.setPhone(rs.getString("phone"));
        a.setEmail(rs.getString("email"));
        a.setRole(rs.getString("role"));
        a.setStatus(rs.getString("status"));
        a.setNote(rs.getString("note"));
        
        long eightHoursInMs = 8 * 60 * 60 * 1000;

        Timestamp loginAt = rs.getTimestamp("last_login_at");
        if (loginAt != null) {
            a.setLastLoginAt(new Timestamp(loginAt.getTime() + eightHoursInMs));
        }
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            a.setCreatedAt(new Timestamp(createdAt.getTime() + eightHoursInMs));
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            a.setUpdatedAt(new Timestamp(updatedAt.getTime() + eightHoursInMs));
        }
        
        return a;
    }
}