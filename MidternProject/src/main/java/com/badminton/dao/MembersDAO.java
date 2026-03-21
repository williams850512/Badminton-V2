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

    // 取得所有會員 (順序改為 1 往下到 6)
    public List<MembersBean> getAllMembers() {
        List<MembersBean> list = new ArrayList<>();
        // 🔴 這裡改為 ASC，ID 就會從 1 開始排
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

    // 更新會員
    public boolean updateMember(MembersBean m) {
        String sql = "UPDATE Members SET full_name=?, phone=?, email=?, gender=?, birthday=?, membership_level=?, updated_at=GETDATE() WHERE member_id=?";
        try (Connection conn = ds.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, m.getFullName());
            ps.setString(2, m.getPhone());
            ps.setString(3, m.getEmail());
            ps.setString(4, m.getGender());
            ps.setDate(5, m.getBirthday());
            ps.setString(6, m.getMembershipLevel());
            ps.setInt(7, m.getMemberId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    //關鍵字查詢
    public List<MembersBean> searchMembers(String keyword) {
        List<MembersBean> list = new ArrayList<>();
        // 使用 LIKE 語法進行模糊查詢，同時比對帳號與姓名
        String sql = "SELECT * FROM Members WHERE username LIKE ? OR full_name LIKE ? ORDER BY member_id ASC";
        
        try (Connection conn = ds.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String wildKeyword = "%" + keyword + "%";
            ps.setString(1, wildKeyword);
            ps.setString(2, wildKeyword);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToBean(rs));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
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

    // 登入
    public MembersBean login(String username, String password) {
        String sql = "SELECT * FROM Members WHERE username = ? AND password = ?";
        try (Connection conn = ds.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToBean(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean register(MembersBean m) {
        String sql = "INSERT INTO Members (username, password, full_name, phone, email, gender, birthday, membership_level) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = ds.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, m.getUsername());
            ps.setString(2, m.getPassword());
            ps.setString(3, m.getFullName());
            ps.setString(4, m.getPhone());
            ps.setString(5, m.getEmail());
            ps.setString(6, m.getGender());
            ps.setDate(7, m.getBirthday());
            ps.setString(8, m.getMembershipLevel());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteMember(int id) {
        String sql = "DELETE FROM Members WHERE member_id = ?";
        try (Connection conn = ds.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

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
        return m;
    }
}