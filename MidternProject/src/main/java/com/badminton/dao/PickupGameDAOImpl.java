package com.badminton.dao;

import javax.naming.InitialContext;
import javax.sql.DataSource;
import com.badminton.model.PickupGameBean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PickupGameDAOImpl implements PickupGameDAO {

	// 取得連線
	private Connection getConnection() throws Exception {
		InitialContext ctx = new InitialContext();
		DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/BadmintonDB");
		return ds.getConnection();
	}

	// 1. 新增活動 (Insert)
	@Override
	public boolean insert(PickupGameBean game) {
		String sql = "INSERT INTO PickupGames (host_id, court_id, game_date, start_time, end_time, max_players, "
				+ "fee_per_person, skill_level, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try (Connection conn = getConnection(); 
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, game.getHostId());
			pstmt.setInt(2, game.getCourtId());
			pstmt.setDate(3, game.getGameDate());
			pstmt.setTime(4, game.getStartTime());
			pstmt.setTime(5, game.getEndTime());
			pstmt.setInt(6, game.getMaxPlayers());
			pstmt.setBigDecimal(7, game.getFeePerPerson());
			pstmt.setString(8, game.getSkillLevel());
			pstmt.setString(9, game.getStatus());

			int count = pstmt.executeUpdate();
			return count > 0;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	// 2. 查詢全部 (含場地名稱，供後台管理使用)
	@Override
	public List<PickupGameBean> getAll() {
		List<PickupGameBean> list = new ArrayList<>();
		String sql = "SELECT g.*, v.venue_name + ' - ' + c.court_name AS court_display, " +
		             "(SELECT COUNT(*) FROM BadmintonDB.dbo.PickupGameSignups s WHERE s.game_id = g.game_id) AS actual_players " +
		             "FROM BadmintonDB.dbo.PickupGames g " +
		             "JOIN BadmintonDB.dbo.Courts c ON g.court_id = c.court_id " +
		             "JOIN BadmintonDB.dbo.Venues v ON c.venue_id = v.venue_id " +
		             "ORDER BY g.game_date DESC";
		
		try (Connection conn = getConnection(); 
			 PreparedStatement pstmt = conn.prepareStatement(sql);
			 ResultSet rs = pstmt.executeQuery()) {
			
			while (rs.next()) {
				PickupGameBean bean = new PickupGameBean();
				bean.setGameId(rs.getInt("game_id"));
				bean.setHostId(rs.getInt("host_id"));
				bean.setCourtId(rs.getInt("court_id"));
				bean.setCourtName(rs.getString("court_display"));
				bean.setGameDate(rs.getDate("game_date"));
				bean.setStartTime(rs.getTime("start_time"));
				bean.setEndTime(rs.getTime("end_time"));
				bean.setMaxPlayers(rs.getInt("max_players"));
				bean.setCurrentPlayers(rs.getInt("actual_players"));
				bean.setFeePerPerson(rs.getBigDecimal("fee_per_person"));
				bean.setSkillLevel(rs.getString("skill_level"));
				bean.setStatus(rs.getString("status"));
				bean.setCreatedAt(rs.getTimestamp("created_at"));
				list.add(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	// 3. 查詢單筆
	@Override
	public PickupGameBean findById(Integer gameId) {
		String sql = "SELECT * FROM PickupGames WHERE game_id = ?";
		PickupGameBean bean = null;
		try (Connection conn = getConnection(); 
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, gameId);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					bean = new PickupGameBean();
					bean.setGameId(rs.getInt("game_id"));
					bean.setHostId(rs.getInt("host_id"));
					bean.setCourtId(rs.getInt("court_id"));
					bean.setGameDate(rs.getDate("game_date"));
					bean.setStartTime(rs.getTime("start_time"));
					bean.setEndTime(rs.getTime("end_time"));
					bean.setMaxPlayers(rs.getInt("max_players"));
					bean.setFeePerPerson(rs.getBigDecimal("fee_per_person"));
					bean.setSkillLevel(rs.getString("skill_level"));
					bean.setStatus(rs.getString("status"));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bean;
	}

	// 4. 修改活動
	@Override
	public boolean update(PickupGameBean game) {
		String sql = "UPDATE PickupGames SET court_id=?, game_date=?, start_time=?, status=? WHERE game_id=?";
		try (Connection conn = getConnection(); 
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, game.getCourtId());
			pstmt.setDate(2, game.getGameDate());
			pstmt.setTime(3, game.getStartTime());
			pstmt.setString(4, game.getStatus());
			pstmt.setInt(5, game.getGameId());
			int count = pstmt.executeUpdate();
			return count > 0;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	// 5. 刪除活動
	@Override
	public boolean delete(Integer gameId) {
		String sql = "DELETE FROM PickupGames WHERE game_id = ?";
		try (Connection conn = getConnection(); 
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, gameId);
			int rowCount = pstmt.executeUpdate();
			return rowCount > 0;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	} 

}