package com.badminton.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.naming.*;
import javax.sql.DataSource;
import com.badminton.model.*;

public class MembersDAO {
	private DataSource ds;

	public MembersDAO() {
		try {
			Context context = new InitialContext();
			ds = (DataSource) context.lookup("java:comp/env/jdbc/BadmintonDB");
		} catch (NamingException e) {
			e.printStackTrace();
		}
	}

	// 1. 註冊 (Create) - 已加入性別與生日
	public boolean register(MembersBean member) {
		String sql = "INSERT INTO Members (username, password, name, phone, email, role, gender, birthday) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
		try (Connection conn = ds.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, member.getUsername());
			ps.setString(2, member.getPassword());
			ps.setString(3, member.getName());
			ps.setString(4, member.getPhone());
			ps.setString(5, member.getEmail());
			ps.setString(6, "user"); // 預設角色
			ps.setString(7, member.getGender());   // 新增：性別
			ps.setDate(8, member.getBirthday());     // 新增：生日 (java.sql.Date)
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// 2. 登入檢查 (Read)
	public MembersBean login(String username, String password) {
		String sql = "SELECT * FROM Members WHERE username = ? AND password = ?";
		try (Connection conn = ds.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, username);
			ps.setString(2, password);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapRowToBean(rs);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	// 3. 修改個人資料 (Update) - 已加入性別與生日
	public boolean updateProfile(MembersBean member) {
		// 這裡補上 gender=? 和 birthday=?
		String sql = "UPDATE Members SET name=?, phone=?, email=?, role=?, gender=?, birthday=?, updated_at=GETDATE() WHERE member_id=?";
		try (Connection conn = ds.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, member.getName());
			ps.setString(2, member.getPhone());
			ps.setString(3, member.getEmail());
			ps.setString(4, member.getRole());
			ps.setString(5, member.getGender());   // 新增
			ps.setDate(6, member.getBirthday());     // 新增
			ps.setInt(7, member.getMemberId());
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// 4. 刪除
	public boolean deleteMember(int memberId) {
		String sql = "DELETE FROM Members WHERE member_id = ?";
		try (Connection conn = ds.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, memberId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// 5. 查詢單筆
	public MembersBean getMemberById(int memberId) {
		String sql = "SELECT * FROM Members WHERE member_id = ?";
		try (Connection conn = ds.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, memberId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapRowToBean(rs);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	// 6. 查詢全部
	public List<MembersBean> getAllMembers() {
		List<MembersBean> list = new ArrayList<>();
		String sql = "SELECT * FROM Members";
		try (Connection conn = ds.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				list.add(mapRowToBean(rs));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	// 輔助方法：統一封裝 ResultSet 轉 Bean 
	// 這裡必須補上 rs.get... 並 set 回 Bean，否則頁面會看不到資料
	private MembersBean mapRowToBean(ResultSet rs) throws SQLException {
		MembersBean m = new MembersBean();
		m.setMemberId(rs.getInt("member_id"));
		m.setUsername(rs.getString("username"));
		m.setName(rs.getString("name"));
		m.setPhone(rs.getString("phone"));
		m.setEmail(rs.getString("email"));
		m.setRole(rs.getString("role"));
		
		// --- 補上這兩行 ---
		m.setGender(rs.getString("gender"));
		m.setBirthday(rs.getDate("birthday"));
		
		m.setCreatedAt(rs.getTimestamp("created_at"));
		m.setUpdatedAt(rs.getTimestamp("updated_at"));
		return m;
	}
}