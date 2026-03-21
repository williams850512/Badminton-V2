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
     * 管理員登入驗證
     */
    public MembersAdminBean login(String username, String password) {
        String sql = "SELECT * FROM Admins WHERE username = ? AND password = ? AND status = 'active'";
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
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 更新登入時間 (存入資料庫時使用當前標準時間)
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
     * 新增管理員 (包含 Note 備注)
     */
    public boolean addAdmin(MembersAdminBean a) {
        String sql = "INSERT INTO Admins (username, password, full_name, gender, birthday, phone, email, role, status, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'active', ?)";
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
            ps.setString(9, a.getNote()); // 寫入備注
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 更新管理員 (包含 Note 備注)
     */
    public boolean updateAdmin(MembersAdminBean a) {
        String sql = "UPDATE Admins SET full_name=?, gender=?, birthday=?, phone=?, email=?, role=?, status=?, note=? WHERE admin_id=?";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getFullName());
            ps.setString(2, a.getGender());
            ps.setDate(3, a.getBirthday());
            ps.setString(4, a.getPhone());
            ps.setString(5, a.getEmail());
            ps.setString(6, a.getRole());
            ps.setString(7, a.getStatus());
            ps.setString(8, a.getNote()); // 更新備注
            ps.setInt(9, a.getAdminId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 封裝 Bean 並修正時差顯示
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
        a.setNote(rs.getString("note")); // 讀取備注
        
        long eightHoursInMs = 8 * 60 * 60 * 1000;

        // 處理登入時間：補足 8 小時
        Timestamp loginAt = rs.getTimestamp("last_login_at");
        if (loginAt != null) {
            a.setLastLoginAt(new Timestamp(loginAt.getTime() + eightHoursInMs));
        }
        
        // 建立時間：同步補足 8 小時
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            a.setCreatedAt(new Timestamp(createdAt.getTime() + eightHoursInMs));
        }
        
        // 更新時間：同步補足 8 小時
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            a.setUpdatedAt(new Timestamp(updatedAt.getTime() + eightHoursInMs));
        }
        
        return a;
    }
}